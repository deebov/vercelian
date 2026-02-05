import Foundation

struct Deployment: Identifiable, Equatable {
    let uid: String
    let name: String
    let url: String
    let created: Int
    let state: DeploymentState
    let target: String?
    let meta: DeploymentMeta?
    let creator: DeploymentCreator?
    let inspectorUrl: String?
    let aliasAssigned: Bool?

    var id: String { uid }

    var createdDate: Date {
        Date(timeIntervalSince1970: TimeInterval(created) / 1000)
    }

    var displayUrl: String {
        url.replacingOccurrences(of: "https://", with: "")
    }

    var isProduction: Bool {
        target == "production"
    }

    // A deployment is "current" if it's production, ready, and has aliases assigned
    var isCurrentProduction: Bool {
        isProduction && state == .ready && (aliasAssigned == true)
    }
}

extension Deployment: Codable {
    enum CodingKeys: String, CodingKey {
        case uid, name, url, created, state, target, meta, creator, inspectorUrl, aliasAssigned
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        created = try container.decode(Int.self, forKey: .created)
        // Handle state - might come as different values
        if let stateValue = try? container.decode(DeploymentState.self, forKey: .state) {
            state = stateValue
        } else {
            state = .queued
        }
        target = try container.decodeIfPresent(String.self, forKey: .target)
        meta = try container.decodeIfPresent(DeploymentMeta.self, forKey: .meta)
        creator = try container.decodeIfPresent(DeploymentCreator.self, forKey: .creator)
        inspectorUrl = try container.decodeIfPresent(String.self, forKey: .inspectorUrl)
        // aliasAssigned can be a Bool, a Number (timestamp), or null
        // If it's a number > 0, that means aliases are assigned (timestamp of when)
        if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: .aliasAssigned) {
            aliasAssigned = boolValue
        } else if let numberValue = try? container.decodeIfPresent(Int.self, forKey: .aliasAssigned) {
            aliasAssigned = numberValue > 0
        } else {
            aliasAssigned = nil
        }
    }
}

enum DeploymentState: String, Codable {
    case building = "BUILDING"
    case error = "ERROR"
    case initializing = "INITIALIZING"
    case queued = "QUEUED"
    case ready = "READY"
    case canceled = "CANCELED"

    var displayName: String {
        switch self {
        case .building: return "Building"
        case .error: return "Error"
        case .initializing: return "Initializing"
        case .queued: return "Queued"
        case .ready: return "Ready"
        case .canceled: return "Canceled"
        }
    }

    var color: String {
        switch self {
        case .building, .initializing, .queued: return "yellow"
        case .error: return "red"
        case .ready: return "green"
        case .canceled: return "gray"
        }
    }
}

struct DeploymentMeta: Codable, Equatable {
    let githubCommitSha: String?
    let githubCommitMessage: String?
    let githubCommitRef: String?
    let githubRepo: String?
    let githubOrg: String?

    enum CodingKeys: String, CodingKey {
        case githubCommitSha
        case githubCommitMessage
        case githubCommitRef
        case githubRepo
        case githubOrg
    }
}

struct DeploymentCreator: Codable, Equatable {
    let uid: String?
    let username: String?
    let email: String?
}

struct DeploymentsResponse: Codable {
    let deployments: [Deployment]
    let pagination: Pagination?
}

struct Pagination: Codable {
    let count: Int
    let next: Int?
    let prev: Int?
}
