import SwiftUI
import AppKit
import Combine

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var eventMonitor: Any?
    private var cancellables = Set<AnyCancellable>()

    private var currentIconState: MenuBarIconState = .normal

    enum MenuBarIconState {
        case normal
        case building
        case error

        var symbolName: String {
            switch self {
            case .normal: return "triangle.fill"
            case .building: return "triangle.fill"
            case .error: return "exclamationmark.triangle.fill"
            }
        }

        var tintColor: NSColor? {
            switch self {
            case .normal: return nil // Template image, follows system
            case .building: return .systemOrange
            case .error: return .systemRed
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupPopover()
        setupEventMonitor()
        setupNotificationObservers()
        requestNotificationPermission()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            updateMenuBarIcon(state: .normal)
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func updateMenuBarIcon(state: MenuBarIconState) {
        guard let button = statusItem.button else { return }

        currentIconState = state
        let settings = SettingsManager.shared

        if settings.dynamicMenuBarIcon {
            // Dynamic icon - changes color based on state
            if let color = state.tintColor {
                let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .medium)
                if let image = NSImage(systemSymbolName: state.symbolName, accessibilityDescription: "Vercelian")?
                    .withSymbolConfiguration(config) {
                    let coloredImage = image.tinted(with: color)
                    coloredImage.isTemplate = false
                    button.image = coloredImage
                }
            } else {
                button.image = NSImage(systemSymbolName: state.symbolName, accessibilityDescription: "Vercelian")
                button.image?.isTemplate = true
            }
        } else {
            // Static icon - always template
            button.image = NSImage(systemSymbolName: "triangle.fill", accessibilityDescription: "Vercelian")
            button.image?.isTemplate = true
        }
    }

    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 380, height: 500)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: ContentView())
    }

    private func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }
    }

    private func setupNotificationObservers() {
        // Listen for deployment status changes
        NotificationCenter.default.publisher(for: .deploymentStatusChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let state = notification.userInfo?["state"] as? MenuBarIconState {
                    self?.updateMenuBarIcon(state: state)
                }
            }
            .store(in: &cancellables)

        // Listen for settings changes
        NotificationCenter.default.publisher(for: .menuBarIconSettingChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateMenuBarIcon(state: self.currentIconState)
            }
            .store(in: &cancellables)
    }

    private func requestNotificationPermission() {
        Task {
            _ = await NotificationManager.shared.requestAuthorization()
        }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
}

// MARK: - NSImage Extension for Tinting

extension NSImage {
    func tinted(with color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()
        return image
    }
}
