import Foundation
import Combine

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    // Keys
    private let notificationsEnabledKey = "notificationsEnabled"
    private let notifyOnSuccessKey = "notifyOnSuccess"
    private let notifyOnFailureKey = "notifyOnFailure"
    private let dynamicMenuBarIconKey = "dynamicMenuBarIcon"
    private let refreshIntervalKey = "refreshInterval"

    // Published properties
    @Published var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: notificationsEnabledKey) }
    }

    @Published var notifyOnSuccess: Bool {
        didSet { defaults.set(notifyOnSuccess, forKey: notifyOnSuccessKey) }
    }

    @Published var notifyOnFailure: Bool {
        didSet { defaults.set(notifyOnFailure, forKey: notifyOnFailureKey) }
    }

    @Published var dynamicMenuBarIcon: Bool {
        didSet {
            defaults.set(dynamicMenuBarIcon, forKey: dynamicMenuBarIconKey)
            NotificationCenter.default.post(name: .menuBarIconSettingChanged, object: nil)
        }
    }

    @Published var refreshInterval: Double {
        didSet { defaults.set(refreshInterval, forKey: refreshIntervalKey) }
    }

    private init() {
        // Set defaults if not already set
        if defaults.object(forKey: notificationsEnabledKey) == nil {
            defaults.set(true, forKey: notificationsEnabledKey)
        }
        if defaults.object(forKey: notifyOnSuccessKey) == nil {
            defaults.set(false, forKey: notifyOnSuccessKey) // Silent by default for success
        }
        if defaults.object(forKey: notifyOnFailureKey) == nil {
            defaults.set(true, forKey: notifyOnFailureKey) // Notify on failures by default
        }
        if defaults.object(forKey: dynamicMenuBarIconKey) == nil {
            defaults.set(true, forKey: dynamicMenuBarIconKey)
        }
        if defaults.object(forKey: refreshIntervalKey) == nil {
            defaults.set(10.0, forKey: refreshIntervalKey)
        }

        // Load values
        notificationsEnabled = defaults.bool(forKey: notificationsEnabledKey)
        notifyOnSuccess = defaults.bool(forKey: notifyOnSuccessKey)
        notifyOnFailure = defaults.bool(forKey: notifyOnFailureKey)
        dynamicMenuBarIcon = defaults.bool(forKey: dynamicMenuBarIconKey)
        refreshInterval = defaults.double(forKey: refreshIntervalKey)
    }

    // MARK: - Helper Methods

    func shouldNotify(for state: DeploymentState) -> Bool {
        guard notificationsEnabled else { return false }

        switch state {
        case .ready:
            return notifyOnSuccess
        case .error:
            return notifyOnFailure
        default:
            return false
        }
    }
}

// Notification for menu bar icon changes
extension Notification.Name {
    static let menuBarIconSettingChanged = Notification.Name("menuBarIconSettingChanged")
    static let deploymentStatusChanged = Notification.Name("deploymentStatusChanged")
}
