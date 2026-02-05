import Foundation
import Combine

@MainActor
final class DeploymentStore: ObservableObject {
    static let shared = DeploymentStore()

    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var teams: [Team] = []
    @Published var selectedTeam: Team?
    @Published var projects: [Project] = []
    @Published var selectedProject: Project?
    @Published var deployments: [Deployment] = []
    @Published var isLoading = false
    @Published var error: String?

    // Set of deployment UIDs that are currently live (one per project)
    @Published var currentProductionDeploymentIds: Set<String> = []

    private var refreshTimer: Timer?
    private let api = VercelAPI.shared
    private let keychain = KeychainManager.shared
    private let notifications = NotificationManager.shared
    private let settings = SettingsManager.shared

    // Track previous deployment states for notifications
    private var previousDeploymentStates: [String: DeploymentState] = [:]

    private init() {
        checkAuthentication()
    }

    // MARK: - Authentication

    func checkAuthentication() {
        isAuthenticated = keychain.getToken() != nil
        if isAuthenticated {
            Task {
                await loadInitialData()
            }
        }
    }

    func login(token: String) async -> Bool {
        isLoading = true
        error = nil

        do {
            let user = try await api.validateToken(token)
            _ = keychain.saveToken(token)
            currentUser = user
            isAuthenticated = true
            await loadInitialData()
            isLoading = false
            return true
        } catch {
            self.error = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func logout() {
        stopAutoRefresh()
        keychain.clearAll()
        isAuthenticated = false
        currentUser = nil
        teams = []
        selectedTeam = nil
        projects = []
        selectedProject = nil
        deployments = []
    }

    // MARK: - Data Loading

    func loadInitialData() async {
        isLoading = true
        error = nil

        do {
            currentUser = try await api.getCurrentUser()
            teams = try await api.getTeams()

            if let savedTeamId = keychain.getTeamId(),
               let team = teams.first(where: { $0.id == savedTeamId }) {
                selectedTeam = team
            }

            await loadProjects()
            await loadDeployments()
            startAutoRefresh()
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func loadProjects() async {
        do {
            projects = try await api.getProjects()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func loadDeployments() async {
        do {
            print("[DeploymentStore] Loading deployments...")
            let newDeployments = try await api.getDeployments(projectId: selectedProject?.id)
            print("[DeploymentStore] Loaded \(newDeployments.count) deployments")

            // Check for state changes and send notifications
            for deployment in newDeployments {
                if let previousState = previousDeploymentStates[deployment.uid],
                   previousState != deployment.state {
                    // State changed - check if we should notify
                    if settings.shouldNotify(for: deployment.state) {
                        notifications.sendDeploymentNotification(
                            projectName: deployment.name,
                            state: deployment.state,
                            commitMessage: deployment.meta?.githubCommitMessage,
                            url: deployment.url
                        )
                    }
                }
                previousDeploymentStates[deployment.uid] = deployment.state
            }

            deployments = newDeployments

            // Compute current production deployment IDs (one per project)
            // The current deployment is the most recent ready production deployment with aliases assigned
            updateCurrentProductionDeployments()

            // Update menu bar icon based on current states
            updateMenuBarIconState()
        } catch {
            print("[DeploymentStore] Error loading deployments: \(error)")
            self.error = error.localizedDescription
        }
    }

    private func updateCurrentProductionDeployments() {
        // Group deployments by project name
        var currentIds = Set<String>()
        var seenProjects = Set<String>()

        // Deployments are already sorted by created date (most recent first)
        for deployment in deployments {
            // Only consider production deployments that are ready and have aliases assigned
            guard deployment.isProduction,
                  deployment.state == .ready,
                  deployment.aliasAssigned == true else {
                continue
            }

            // Only take the first (most recent) one per project
            if !seenProjects.contains(deployment.name) {
                seenProjects.insert(deployment.name)
                currentIds.insert(deployment.uid)
            }
        }

        currentProductionDeploymentIds = currentIds
    }

    private func updateMenuBarIconState() {
        // Determine the overall state for the menu bar icon
        let hasBuilding = deployments.contains { $0.state == .building || $0.state == .initializing || $0.state == .queued }
        let hasError = deployments.prefix(5).contains { $0.state == .error } // Only check recent deployments for error

        let iconState: String
        if hasBuilding {
            iconState = "building"
        } else if hasError {
            iconState = "error"
        } else {
            iconState = "normal"
        }

        // Post notification for AppDelegate to update icon
        NotificationCenter.default.post(
            name: .deploymentStatusChanged,
            object: nil,
            userInfo: ["state": menuBarIconState(from: iconState)]
        )
    }

    private func menuBarIconState(from string: String) -> AppDelegate.MenuBarIconState {
        switch string {
        case "building": return .building
        case "error": return .error
        default: return .normal
        }
    }

    func refresh() async {
        await loadDeployments()
    }

    // MARK: - Team Selection

    func selectTeam(_ team: Team?) {
        selectedTeam = team
        if let team = team {
            _ = keychain.saveTeamId(team.id)
        } else {
            _ = keychain.deleteTeamId()
        }

        Task {
            await loadProjects()
            await loadDeployments()
        }
    }

    // MARK: - Project Selection

    func selectProject(_ project: Project?) {
        selectedProject = project
        Task {
            await loadDeployments()
        }
    }

    // MARK: - Deployment Actions

    func cancelDeployment(_ deployment: Deployment) async {
        do {
            try await api.cancelDeployment(id: deployment.uid)
            await loadDeployments()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func redeployDeployment(_ deployment: Deployment) async {
        do {
            _ = try await api.redeployDeployment(id: deployment.uid)
            await loadDeployments()
        } catch {
            self.error = error.localizedDescription
        }
    }

    // MARK: - Auto Refresh

    func startAutoRefresh() {
        stopAutoRefresh()

        refreshTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.loadDeployments()
            }
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
