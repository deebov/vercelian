import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noToken
    case invalidResponse
    case httpError(Int, String?)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noToken:
            return "No access token configured"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code, let message):
            return "HTTP Error \(code): \(message ?? "Unknown error")"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

final class VercelAPI {
    static let shared = VercelAPI()

    private let baseURL = "https://api.vercel.com"
    private let session: URLSession
    private let logFile: URL

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)

        // Setup log file
        let tempDir = FileManager.default.temporaryDirectory
        self.logFile = tempDir.appendingPathComponent("vercelian_debug.log")
        log("VercelAPI initialized")
    }

    private func log(_ message: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logMessage = "[\(timestamp)] \(message)\n"
        print(logMessage, terminator: "")

        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFile.path) {
                if let handle = try? FileHandle(forWritingTo: logFile) {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    handle.closeFile()
                }
            } else {
                try? data.write(to: logFile)
            }
        }
    }

    private var token: String? {
        KeychainManager.shared.getToken()
    }

    private var teamId: String? {
        KeychainManager.shared.getTeamId()
    }

    // MARK: - User

    func getCurrentUser() async throws -> User {
        let response: UserResponse = try await request(endpoint: "/v2/user")
        return response.user
    }

    // MARK: - Teams

    func getTeams() async throws -> [Team] {
        let response: TeamsResponse = try await request(endpoint: "/v2/teams")
        return response.teams
    }

    // MARK: - Projects

    func getProjects(limit: Int = 20) async throws -> [Project] {
        var endpoint = "/v9/projects?limit=\(limit)"
        if let teamId = teamId {
            endpoint += "&teamId=\(teamId)"
        }
        let response: ProjectsResponse = try await request(endpoint: endpoint)
        return response.projects
    }

    // MARK: - Deployments

    func getDeployments(projectId: String? = nil, limit: Int = 20) async throws -> [Deployment] {
        var endpoint = "/v6/deployments?limit=\(limit)"

        if let projectId = projectId {
            endpoint += "&projectId=\(projectId)"
        }

        if let teamId = teamId {
            endpoint += "&teamId=\(teamId)"
        }

        log("Fetching deployments: \(endpoint)")
        let response: DeploymentsResponse = try await request(endpoint: endpoint)
        log("Got \(response.deployments.count) deployments")
        return response.deployments
    }

    func getDeployment(id: String) async throws -> Deployment {
        var endpoint = "/v13/deployments/\(id)"
        if let teamId = teamId {
            endpoint += "?teamId=\(teamId)"
        }
        return try await request(endpoint: endpoint)
    }

    // MARK: - Cancel Deployment

    func cancelDeployment(id: String) async throws {
        var endpoint = "/v12/deployments/\(id)/cancel"
        if let teamId = teamId {
            endpoint += "?teamId=\(teamId)"
        }
        let _: Deployment = try await request(endpoint: endpoint, method: "PATCH")
    }

    // MARK: - Redeploy

    func redeployDeployment(id: String) async throws -> Deployment {
        var endpoint = "/v13/deployments?forceNew=1"
        if let teamId = teamId {
            endpoint += "&teamId=\(teamId)"
        }

        struct RedeployRequest: Codable {
            let deploymentId: String
            let name: String
            let target: String?
        }

        let deployment = try await getDeployment(id: id)
        let body = RedeployRequest(
            deploymentId: id,
            name: deployment.name,
            target: deployment.target
        )

        return try await request(endpoint: endpoint, method: "POST", body: body)
    }

    // MARK: - Private Request Method

    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let token = token else {
            throw APIError.noToken
        }

        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        log("Response status: \(httpResponse.statusCode) for \(endpoint)")

        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
            let errorMessage = String(data: data, encoding: .utf8)
            log("Error response: \(errorMessage ?? "nil")")
            throw APIError.httpError(httpResponse.statusCode, errorMessage)
        }

        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            let rawJson = String(data: data, encoding: .utf8) ?? "nil"
            log("Decoding error: \(error)")
            log("Raw JSON (first 1000 chars): \(String(rawJson.prefix(1000)))")
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Validation

    func validateToken(_ token: String) async throws -> User {
        guard let url = URL(string: baseURL + "/v2/user") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
            let errorMessage = String(data: data, encoding: .utf8)
            throw APIError.httpError(httpResponse.statusCode, errorMessage)
        }

        let decoder = JSONDecoder()
        let userResponse = try decoder.decode(UserResponse.self, from: data)
        return userResponse.user
    }
}
