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
    /// Shown on the sign-in screen when the app signed itself out.
    @Published var signedOutReason: String?

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
        if DemoData.isEnabled {
            showDemoAccount()
            return
        }
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
        if DemoData.isEnabled {
            showDemoAccount()
            return true
        }
        isLoading = true
        error = nil

        do {
            let user = try await api.validateToken(token)
            _ = keychain.saveToken(token)
            currentUser = user
            isAuthenticated = true
            signedOutReason = nil
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
        if !DemoData.isEnabled {
            keychain.clearAll()
        }
        isAuthenticated = false
        currentUser = nil
        teams = []
        selectedTeam = nil
        projects = []
        selectedProject = nil
        deployments = []
        // Otherwise the next account's deployments get diffed against the
        // previous account's and fire spurious notifications.
        previousDeploymentStates.removeAll()
        currentProductionDeploymentIds = []
        error = nil
        signedOutReason = nil
        // Don't leave the icon orange or red for an account that's gone.
        updateMenuBarIconState()
    }

    /// Routes a failed request: a dead token signs the user out with an
    /// explanation, since every later request would fail the same way and
    /// the list would otherwise sit empty with no hint why. Anything else
    /// is shown in the list.
    private func handle(_ error: Error) {
        if case APIError.invalidToken = error {
            logout()
            signedOutReason = "Your access token expired or was revoked. Create a new token to sign back in."
            return
        }
        self.error = error.localizedDescription
    }

    // MARK: - Data Loading

    func loadInitialData() async {
        if DemoData.isEnabled {
            showDemoAccount()
            return
        }
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
        } catch {
            handle(error)
        }

        isLoading = false
        if isAuthenticated {
            startAutoRefresh()
        }
    }

    func loadProjects() async {
        guard !DemoData.isEnabled else { return }
        let team = selectedTeam?.id
        do {
            let loaded = try await api.getProjects()
            guard isAuthenticated, selectedTeam?.id == team else { return }
            projects = loaded
        } catch {
            handle(error)
        }
    }

    func loadDeployments() async {
        if DemoData.isEnabled {
            showDemoDeployments()
            return
        }
        let team = selectedTeam?.id
        let project = selectedProject?.id
        do {
            let newDeployments = try await api.getDeployments(projectId: project)
            // Switching team or project while this was in flight would
            // otherwise let the older response overwrite the newer one.
            guard isAuthenticated, selectedTeam?.id == team, selectedProject?.id == project else { return }

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
            self.error = nil
        } catch {
            handle(error)
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
        // Match the icon to the first visible deployment (top row in the current list).
        let latestState = deployments.first?.state
        let iconState: String
        switch latestState {
        case .building, .initializing, .queued:
            iconState = "building"
        case .error:
            iconState = "error"
        default:
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
        // If the first load failed there is no account data yet; retry all of it.
        // Requests can take up to 30s to time out, so skip a tick rather than
        // stack a second attempt on one still in flight.
        if currentUser == nil {
            guard !isLoading else { return }
            await loadInitialData()
        } else {
            await loadDeployments()
        }
    }

    // MARK: - Team Selection

    func selectTeam(_ team: Team?) {
        selectedTeam = team
        // A project belongs to one team; keeping it would filter the new
        // team's deployments by a project it doesn't have.
        selectedProject = nil
        if !DemoData.isEnabled {
            if let team = team {
                _ = keychain.saveTeamId(team.id)
            } else {
                _ = keychain.deleteTeamId()
            }
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
        guard !DemoData.isEnabled else { return }
        do {
            try await api.cancelDeployment(id: deployment.uid)
            await loadDeployments()
        } catch {
            handle(error)
        }
    }

    func redeployDeployment(_ deployment: Deployment) async {
        guard !DemoData.isEnabled else { return }
        do {
            try await api.redeployDeployment(id: deployment.uid)
            await loadDeployments()
        } catch {
            handle(error)
        }
    }

    // MARK: - Demo

    /// Fills the store from DemoData. Never touches the Keychain or the
    /// network, and starts no refresh timer.
    private func showDemoAccount() {
        isAuthenticated = true
        currentUser = DemoData.user
        teams = DemoData.teams
        selectedTeam = DemoData.teams.first
        projects = DemoData.projects
        showDemoDeployments()
    }

    private func showDemoDeployments() {
        let all = DemoData.deployments
        deployments = selectedProject.map { project in all.filter { $0.name == project.name } } ?? all
        updateCurrentProductionDeployments()
        updateMenuBarIconState()
    }

    // MARK: - Auto Refresh

    func startAutoRefresh() {
        stopAutoRefresh()

        refreshTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.refresh()
            }
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
