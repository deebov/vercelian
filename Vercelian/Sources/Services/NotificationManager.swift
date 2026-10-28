import Foundation
import UserNotifications
import AppKit

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized = false

    // Check if we have a valid bundle identifier for notifications
    private var canUseNotifications: Bool {
        Bundle.main.bundleIdentifier != nil
    }

    private init() {
        Task {
            await checkAuthorization()
        }
    }

    func requestAuthorization() async -> Bool {
        guard canUseNotifications else { return false }

        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            return granted
        } catch {
            return false
        }
    }

    func checkAuthorization() async {
        guard canUseNotifications else {
            isAuthorized = false
            return
        }

        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }

    func sendDeploymentNotification(
        projectName: String,
        state: DeploymentState,
        commitMessage: String?,
        url: String?
    ) {
        guard canUseNotifications else { return }
        guard isAuthorized else { return }
        guard SettingsManager.shared.notificationsEnabled else { return }

        // Only notify on completion states
        guard state == .ready || state == .error || state == .canceled else { return }

        // Check specific notification settings
        if state == .ready && !SettingsManager.shared.notifyOnSuccess { return }
        if state == .error && !SettingsManager.shared.notifyOnFailure { return }

        let content = UNMutableNotificationContent()

        switch state {
        case .ready:
            content.title = "Deployment Ready"
            content.sound = .default
        case .error:
            content.title = "Deployment Failed"
            content.sound = UNNotificationSound.defaultCritical
        case .canceled:
            content.title = "Deployment Canceled"
            content.sound = .default
        default:
            return
        }

        // Two lines: the title, then the commit's first line in the body's
        // regular weight (a subtitle would be bold). Without a commit message,
        // the project name.
        let subject = commitMessage?.split(whereSeparator: \.isNewline).first.map(String.init)
        content.body = subject ?? projectName

        if let url = url {
            content.userInfo = ["url": url]
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
