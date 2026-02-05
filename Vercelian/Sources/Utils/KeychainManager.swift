import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()

    private let service = "com.vercelian.app"
    private let tokenKey = "vercel_access_token"
    private let teamIdKey = "vercel_team_id"

    // In-memory cache to avoid repeated keychain access prompts
    private var cachedToken: String?
    private var cachedTeamId: String?
    private var tokenLoaded = false
    private var teamIdLoaded = false

    private init() {}

    // MARK: - Token Management

    func saveToken(_ token: String) -> Bool {
        delete(key: tokenKey)

        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            cachedToken = token
            tokenLoaded = true
        }
        return status == errSecSuccess
    }

    func getToken() -> String? {
        // Return cached value if already loaded
        if tokenLoaded {
            return cachedToken
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        tokenLoaded = true
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            cachedToken = nil
            return nil
        }

        cachedToken = token
        return token
    }

    func deleteToken() -> Bool {
        cachedToken = nil
        tokenLoaded = true
        return delete(key: tokenKey)
    }

    // MARK: - Team ID Management

    func saveTeamId(_ teamId: String) -> Bool {
        delete(key: teamIdKey)

        let data = teamId.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: teamIdKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            cachedTeamId = teamId
            teamIdLoaded = true
        }
        return status == errSecSuccess
    }

    func getTeamId() -> String? {
        // Return cached value if already loaded
        if teamIdLoaded {
            return cachedTeamId
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: teamIdKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        teamIdLoaded = true
        guard status == errSecSuccess,
              let data = result as? Data,
              let teamId = String(data: data, encoding: .utf8) else {
            cachedTeamId = nil
            return nil
        }

        cachedTeamId = teamId
        return teamId
    }

    func deleteTeamId() -> Bool {
        cachedTeamId = nil
        teamIdLoaded = true
        return delete(key: teamIdKey)
    }

    // MARK: - Private Helpers

    @discardableResult
    private func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    func clearAll() {
        _ = deleteToken()
        _ = deleteTeamId()
        cachedToken = nil
        cachedTeamId = nil
        tokenLoaded = false
        teamIdLoaded = false
    }
}
