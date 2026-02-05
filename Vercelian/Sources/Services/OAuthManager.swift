import Foundation
import CryptoKit
import AppKit

@MainActor
final class OAuthManager: ObservableObject {
    static let shared = OAuthManager()

    // Vercel OAuth endpoints (Sign in with Vercel)
    private let authorizationURL = "https://vercel.com/oauth/authorize"
    private let tokenURL = "https://api.vercel.com/login/oauth/token"

    // Vercelian OAuth App credentials
    private let clientId = "cl_DWYG4Akiq0eNKosBi6lKgMt0eAoaZIDu"
    private let clientSecret = ""

    // Local callback server
    private var server: LocalHTTPServer?

    // PKCE values
    private var codeVerifier: String?
    private var state: String?

    @Published var isAuthenticating = false
    @Published var authError: String?

    private var continuation: CheckedContinuation<String, Error>?

    private init() {}

    enum OAuthError: LocalizedError {
        case serverStartFailed
        case userCancelled
        case invalidResponse
        case tokenExchangeFailed(String)
        case networkError(Error)
        case stateMismatch

        var errorDescription: String? {
            switch self {
            case .serverStartFailed:
                return "Failed to start authentication server"
            case .userCancelled:
                return "Authentication was cancelled"
            case .invalidResponse:
                return "Invalid response from Vercel"
            case .tokenExchangeFailed(let message):
                return "Authentication failed: \(message)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .stateMismatch:
                return "Security validation failed. Please try again."
            }
        }
    }

    // MARK: - Public Methods

    /// Start OAuth flow (public client - no secret needed)
    func startOAuthFlow() async throws -> String {

        isAuthenticating = true
        authError = nil

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            // Generate PKCE values
            codeVerifier = generateCodeVerifier()
            state = generateRandomString(length: 32)

            guard let codeVerifier = codeVerifier,
                  let codeChallenge = generateCodeChallenge(from: codeVerifier) else {
                isAuthenticating = false
                continuation.resume(throwing: OAuthError.invalidResponse)
                return
            }

            // Start local server
            server = LocalHTTPServer()
            guard let port = server?.start() else {
                isAuthenticating = false
                continuation.resume(throwing: OAuthError.serverStartFailed)
                return
            }

            let redirectURI = "http://127.0.0.1:\(port)/callback"

            // Store for token exchange
            server?.clientId = clientId
            server?.clientSecret = clientSecret
            server?.redirectURI = redirectURI
            server?.codeVerifier = codeVerifier
            server?.expectedState = state

            // Build authorization URL
            var components = URLComponents(string: authorizationURL)!
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "code_challenge", value: codeChallenge),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "scope", value: "openid offline_access"),
                URLQueryItem(name: "state", value: state)
            ]

            guard let authURL = components.url else {
                server?.stop()
                isAuthenticating = false
                continuation.resume(throwing: OAuthError.invalidResponse)
                return
            }

            // Set up callbacks
            server?.onSuccess = { [weak self] token in
                Task { @MainActor in
                    self?.isAuthenticating = false
                    self?.server?.stop()
                    self?.continuation?.resume(returning: token)
                    self?.continuation = nil
                }
            }

            server?.onError = { [weak self] error in
                Task { @MainActor in
                    self?.isAuthenticating = false
                    self?.authError = error.localizedDescription
                    self?.server?.stop()
                    self?.continuation?.resume(throwing: error)
                    self?.continuation = nil
                }
            }

            // Open browser
            NSWorkspace.shared.open(authURL)
        }
    }

    /// Cancel ongoing OAuth flow
    func cancelOAuth() {
        isAuthenticating = false
        server?.stop()
        server = nil
        continuation?.resume(throwing: OAuthError.userCancelled)
        continuation = nil
    }

    // MARK: - PKCE Helpers

    private func generateCodeVerifier() -> String {
        generateRandomString(length: 64)
    }

    private func generateCodeChallenge(from verifier: String) -> String? {
        guard let data = verifier.data(using: .utf8) else { return nil }
        let hash = SHA256.hash(data: data)
        return Data(hash).base64URLEncodedString()
    }

    private func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}

// MARK: - Base64 URL Encoding

extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

// MARK: - Local HTTP Server

final class LocalHTTPServer: @unchecked Sendable {
    private var serverSocket: Int32 = -1
    private var isRunning = false
    private var port: UInt16 = 0
    private var listenQueue: DispatchQueue?

    // OAuth config
    var clientId: String?
    var clientSecret: String?
    var redirectURI: String?
    var codeVerifier: String?
    var expectedState: String?

    // Callbacks
    var onSuccess: ((String) -> Void)?
    var onError: ((OAuthManager.OAuthError) -> Void)?

    func start() -> UInt16? {
        serverSocket = socket(AF_INET, SOCK_STREAM, 0)
        guard serverSocket >= 0 else { return nil }

        var reuseAddr: Int32 = 1
        setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &reuseAddr, socklen_t(MemoryLayout<Int32>.size))

        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = UInt16(9876).bigEndian // Fixed port for OAuth callback
        addr.sin_addr.s_addr = inet_addr("127.0.0.1")

        let bindResult = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                bind(serverSocket, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }

        guard bindResult >= 0 else {
            close(serverSocket)
            return nil
        }

        var assignedAddr = sockaddr_in()
        var addrLen = socklen_t(MemoryLayout<sockaddr_in>.size)
        _ = withUnsafeMutablePointer(to: &assignedAddr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                getsockname(serverSocket, $0, &addrLen)
            }
        }
        port = UInt16(bigEndian: assignedAddr.sin_port)

        guard listen(serverSocket, 1) >= 0 else {
            close(serverSocket)
            return nil
        }

        isRunning = true
        listenQueue = DispatchQueue(label: "oauth.server", qos: .userInitiated)
        listenQueue?.async { [weak self] in
            self?.acceptConnections()
        }

        return port
    }

    func stop() {
        isRunning = false
        if serverSocket >= 0 {
            close(serverSocket)
            serverSocket = -1
        }
    }

    private func acceptConnections() {
        while isRunning {
            var clientAddr = sockaddr_in()
            var addrLen = socklen_t(MemoryLayout<sockaddr_in>.size)

            let clientSocket = withUnsafeMutablePointer(to: &clientAddr) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    accept(serverSocket, $0, &addrLen)
                }
            }

            guard clientSocket >= 0, isRunning else { continue }

            var buffer = [UInt8](repeating: 0, count: 8192)
            let bytesRead = read(clientSocket, &buffer, buffer.count)

            if bytesRead > 0 {
                let request = String(bytes: buffer[0..<bytesRead], encoding: .utf8) ?? ""
                handleRequest(request, clientSocket: clientSocket)
            }

            close(clientSocket)
        }
    }

    private func handleRequest(_ request: String, clientSocket: Int32) {
        guard let firstLine = request.split(separator: "\r\n").first,
              let pathPart = firstLine.split(separator: " ").dropFirst().first else {
            sendErrorPage(clientSocket, message: "Invalid request")
            return
        }

        let path = String(pathPart)

        guard path.starts(with: "/callback"),
              let components = URLComponents(string: "http://localhost\(path)"),
              let queryItems = components.queryItems else {
            sendErrorPage(clientSocket, message: "Invalid callback")
            return
        }

        // Check for OAuth error
        if let error = queryItems.first(where: { $0.name == "error" })?.value {
            let description = queryItems.first(where: { $0.name == "error_description" })?.value ?? error
            sendErrorPage(clientSocket, message: description)
            onError?(.tokenExchangeFailed(description))
            return
        }

        // Verify state
        let receivedState = queryItems.first(where: { $0.name == "state" })?.value
        guard receivedState == expectedState else {
            sendErrorPage(clientSocket, message: "Security validation failed")
            onError?(.stateMismatch)
            return
        }

        // Get authorization code
        guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
            sendErrorPage(clientSocket, message: "No authorization code received")
            onError?(.invalidResponse)
            return
        }

        // Show success page immediately
        sendSuccessPage(clientSocket)

        // Exchange code for token
        Task {
            await exchangeCodeForToken(code: code)
        }
    }

    private func exchangeCodeForToken(code: String) async {
        guard let clientId = clientId,
              let clientSecret = clientSecret,
              let redirectURI = redirectURI,
              let codeVerifier = codeVerifier else {
            onError?(.invalidResponse)
            return
        }

        guard let url = URL(string: "https://api.vercel.com/login/oauth/token") else {
            onError?(.invalidResponse)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Token exchange with client secret
        let params = [
            "grant_type": "authorization_code",
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code,
            "code_verifier": codeVerifier,
            "redirect_uri": redirectURI
        ]

        let body = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")

        request.httpBody = body.data(using: .utf8)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                onError?(.invalidResponse)
                return
            }

            if httpResponse.statusCode != 200 {
                let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
                onError?(.tokenExchangeFailed(errorMsg))
                return
            }

            struct TokenResponse: Codable {
                let access_token: String
                let token_type: String?
                let expires_in: Int?
                let refresh_token: String?
            }

            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            onSuccess?(tokenResponse.access_token)

        } catch {
            onError?(.networkError(error))
        }
    }

    private func sendSuccessPage(_ socket: Int32) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Vercelian - Success</title>
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                    background: #000;
                    color: #fff;
                }
                .container { text-align: center; padding: 40px; }
                .check {
                    width: 80px;
                    height: 80px;
                    background: #00d68f;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                    font-size: 40px;
                }
                h1 { font-size: 28px; margin-bottom: 12px; }
                p { color: #888; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="check">✓</div>
                <h1>You're signed in!</h1>
                <p>You can close this window and return to Vercelian.</p>
            </div>
            <script>setTimeout(() => window.close(), 2000);</script>
        </body>
        </html>
        """
        sendResponse(socket, status: "200 OK", html: html)
    }

    private func sendErrorPage(_ socket: Int32, message: String) {
        let escapedMessage = message
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Vercelian - Error</title>
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                    background: #0a0a0a;
                    color: #fff;
                }
                .container { text-align: center; padding: 40px; max-width: 400px; }
                .error-icon {
                    width: 80px;
                    height: 80px;
                    background: #ef4444;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                    font-size: 40px;
                }
                h1 { font-size: 28px; margin-bottom: 12px; }
                p { color: #f87171; margin-bottom: 8px; }
                .hint { color: #666; font-size: 14px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="error-icon">✕</div>
                <h1>Authentication Failed</h1>
                <p>\(escapedMessage)</p>
                <p class="hint">Please close this window and try again.</p>
            </div>
        </body>
        </html>
        """
        sendResponse(socket, status: "400 Bad Request", html: html)
    }

    private func sendResponse(_ socket: Int32, status: String, html: String) {
        let response = "HTTP/1.1 \(status)\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: \(html.utf8.count)\r\nConnection: close\r\n\r\n\(html)"
        _ = response.withCString { write(socket, $0, strlen($0)) }
    }
}
