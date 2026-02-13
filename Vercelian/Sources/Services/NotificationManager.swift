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
        guard canUseNotifications else {
            print("Notifications not available - no bundle identifier")
            return false
        }

        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            return granted
        } catch {
            print("Notification authorization error: \(error)")
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
            content.body = "\(projectName) deployed successfully"
            content.sound = .default
        case .error:
            content.title = "Deployment Failed"
            content.body = "\(projectName) deployment failed"
            content.sound = UNNotificationSound.defaultCritical
        case .canceled:
            content.title = "Deployment Canceled"
            content.body = "\(projectName) deployment was canceled"
            content.sound = .default
        default:
            return
        }

        if let message = commitMessage {
            content.subtitle = String(message.prefix(50))
        }

        if let url = url {
            content.userInfo = ["url": url]
        }

        // Attach app icon
        if let iconURL = writeAppIconToTemp() {
            if let attachment = try? UNNotificationAttachment(identifier: "appIcon", url: iconURL, options: nil) {
                content.attachments = [attachment]
            }
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
    }

    private func writeAppIconToTemp() -> URL? {
        guard let icon = NSImage(named: "AppIcon") else { return nil }
        guard let tiff = icon.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let png = bitmap.representation(using: .png, properties: [:]) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("vercelian_icon.png")
        try? png.write(to: url)
        return url
    }
}
