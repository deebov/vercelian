import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noToken
    case invalidToken
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
        case .invalidToken:
            return "Your access token is invalid, expired, or was revoked."
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code, let message):
            if let message = message {
                return "Vercel returned an error (\(code)): \(message)"
            }
            return "Vercel returned an error (\(code))"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }

    /// How Vercel refuses a request beyond a token's scope. A token limited
    /// to a project gets a 404 for the user and a 403 for the team list.
    var isOutOfScope: Bool {
        if case .httpError(let code, _) = self {
            return code == 403 || code == 404
        }
        return false
    }
}

final class VercelAPI {
    static let shared = VercelAPI()

    private let baseURL = "https://api.vercel.com"
    private let session: URLSession

    private init() {
        // Ephemeral: responses carry account data and are re-fetched every
        // poll, so nothing (cache, cookies) should be written to disk.
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    /// Debug-only. Response bodies carry account data, so nothing here is
    /// compiled into release builds.
    private func log(_ message: @autoclosure () -> String) {
        #if DEBUG
        NSLog("[Vercelian.API] %@", message())
        #endif
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

    /// A page of deployments, newest first. Pass a page's `pagination.next`
    /// as `until` for the page after it.
    func getDeployments(projectId: String? = nil, until: Int? = nil, limit: Int = 20) async throws -> DeploymentsResponse {
        var endpoint = "/v6/deployments?limit=\(limit)"

        if let projectId = projectId {
            endpoint += "&projectId=\(projectId)"
        }

        if let until = until {
            endpoint += "&until=\(until)"
        }

        if let teamId = teamId {
            endpoint += "&teamId=\(teamId)"
        }

        log("Fetching deployments: \(endpoint)")
        let response: DeploymentsResponse = try await request(endpoint: endpoint)
        log("Got \(response.deployments.count) deployments")
        return response
    }

    // MARK: - Cancel Deployment

    func cancelDeployment(id: String) async throws {
        var endpoint = "/v12/deployments/\(id)/cancel"
        if let teamId = teamId {
            endpoint += "?teamId=\(teamId)"
        }
        try await requestVoid(endpoint: endpoint, method: "PATCH")
    }

    // MARK: - Redeploy

    func redeployDeployment(_ deployment: Deployment) async throws {
        var endpoint = "/v13/deployments?forceNew=1"
        if let teamId = teamId {
            endpoint += "&teamId=\(teamId)"
        }

        struct RedeployRequest: Codable {
            let deploymentId: String
            let name: String
            let target: String?
        }

        // The name and target come from the list. Fetching the deployment
        // again would get /v13's shape (id, createdAt, readyState), which
        // Deployment can't decode.
        let body = RedeployRequest(
            deploymentId: deployment.uid,
            name: deployment.name,
            target: deployment.target
        )

        // Encode here where concrete type is known (avoids Encodable existential issue)
        let bodyData = try JSONEncoder().encode(body)
        log("Redeploy request body: \(String(data: bodyData, encoding: .utf8) ?? "nil")")
        try await requestVoid(endpoint: endpoint, method: "POST", bodyData: bodyData)
    }

    // MARK: - Private Request Method

    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        token explicitToken: String? = nil
    ) async throws -> T {
        guard let token = explicitToken ?? token else {
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
            log("Error response: \(String(data: data, encoding: .utf8) ?? "nil")")
            throw httpError(status: httpResponse.statusCode, data: data)
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

    private func requestVoid(
        endpoint: String,
        method: String = "GET",
        bodyData: Data? = nil
    ) async throws {
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
        request.httpBody = bodyData

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        log("Response status: \(httpResponse.statusCode) for \(endpoint)")

        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
            log("Error response: \(String(data: data, encoding: .utf8) ?? "nil")")
            throw httpError(status: httpResponse.statusCode, data: data)
        }
    }

    /// Maps a non-2xx response to an error. Vercel answers a revoked or
    /// expired token with 403 and `"invalidToken": true` (a 403 without the
    /// flag means the token lacks access to that team or project), and puts
    /// a readable reason in `error.message`.
    private func httpError(status: Int, data: Data) -> APIError {
        struct Envelope: Decodable {
            struct Body: Decodable {
                let message: String?
                let invalidToken: Bool?
            }
            let error: Body?
        }
        let body = (try? JSONDecoder().decode(Envelope.self, from: data))?.error

        if status == 401 || body?.invalidToken == true {
            return .invalidToken
        }
        return .httpError(status, body?.message)
    }

    // MARK: - Validation

    /// Checks a token before it's saved, and returns its account. A token
    /// Vercel won't show the account, such as one limited to a project,
    /// passes if it can list projects, and returns nil.
    func validateToken(_ token: String) async throws -> User? {
        do {
            let response: UserResponse = try await request(endpoint: "/v2/user", token: token)
            return response.user
        } catch let error as APIError where error.isOutOfScope {
            let _: ProjectsResponse = try await request(endpoint: "/v9/projects?limit=1", token: token)
            return nil
        }
    }
}
