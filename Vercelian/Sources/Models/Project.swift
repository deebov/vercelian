import Foundation

struct Project: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let framework: String?
    let latestDeployments: [LatestDeployment]?
    let updatedAt: Int?

    var updatedDate: Date? {
        guard let updatedAt = updatedAt else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(updatedAt) / 1000)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct LatestDeployment: Codable, Equatable {
    let id: String
    let createdAt: Int?
    let state: String?
}

struct ProjectsResponse: Codable {
    let projects: [Project]
    let pagination: Pagination?
}

struct Team: Identifiable, Codable, Equatable {
    let id: String
    let slug: String
    let name: String?

    var displayName: String {
        name ?? slug
    }
}

struct TeamsResponse: Codable {
    let teams: [Team]
    let pagination: Pagination?
}

struct User: Codable {
    let id: String
    let email: String
    let name: String?
    let username: String?

    var displayName: String {
        name ?? username ?? email
    }
}

struct UserResponse: Codable {
    let user: User
}
