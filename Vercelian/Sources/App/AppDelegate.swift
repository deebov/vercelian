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
        // The store does the polling that drives notifications and the icon.
        // ContentView's @StateObject only creates it when the popover first
        // opens, so without this the app sat idle after every launch until
        // it was clicked. Created after the observers so no icon update is
        // posted before anyone is listening.
        _ = DeploymentStore.shared
        requestNotificationPermission()

        #if DEBUG
        // Screenshot tooling (see DemoData): open the popover without a click.
        if DemoData.showsPopoverAtLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.togglePopover()
            }
        }
        if DemoData.rendersToStandardOutput {
            renderPopoverContent()
        }
        if DemoData.sendsNotification, let failed = DemoData.deployments.first(where: { $0.state == .error }) {
            // After NotificationManager has read the authorization status.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NotificationManager.shared.sendDeploymentNotification(
                    projectName: failed.name,
                    state: failed.state,
                    commitMessage: failed.meta?.githubCommitMessage,
                    url: failed.url
                )
            }
        }
        #endif
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            updateMenuBarIcon(state: .normal)
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func makeSharpTriangleImage(size: CGFloat = 16) -> NSImage {
        let height = size * 0.875
        let image = NSImage(size: NSSize(width: size, height: height))
        image.lockFocus()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: size / 2, y: height))
        path.line(to: NSPoint(x: size, y: 0))
        path.line(to: NSPoint(x: 0, y: 0))
        path.close()
        NSColor.black.setFill()
        path.fill()
        image.unlockFocus()
        image.isTemplate = true
        return image
    }

    private func updateMenuBarIcon(state: MenuBarIconState) {
        guard let button = statusItem.button else { return }

        currentIconState = state
        let settings = SettingsManager.shared

        if settings.dynamicMenuBarIcon, let color = state.tintColor {
            let image = makeSharpTriangleImage()
            let coloredImage = image.tinted(with: color)
            coloredImage.isTemplate = false
            button.image = coloredImage
        } else {
            button.image = makeSharpTriangleImage()
        }
    }

    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 380, height: 500)
        popover.behavior = .transient
        popover.animates = true
        // Hand the arrow to the content, which paints it the same colour as
        // the rest of the popover. Otherwise the arrow shows the system
        // popover material, grey against the content's own background.
        popover.hasFullSizeContent = true
        popover.contentViewController = PopoverContentController()

        #if DEBUG
        // Screenshot tooling (see DemoData).
        if let appearance = DemoData.forcedAppearance {
            popover.appearance = NSAppearance(named: appearance)
        }
        #endif
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

    #if DEBUG
    /// Screenshot tooling (see DemoData): hosts the popover's content in a
    /// window that reports a 4x backing scale, so SwiftUI rasterizes text and
    /// symbols at 4x, then writes it to standard output and quits.
    private func renderPopoverContent() {
        let window = HiDPIWindow(contentRect: NSRect(x: -10_000, y: -10_000, width: 380, height: 500),
                                 styleMask: .borderless, backing: .buffered, defer: false)
        if let appearance = DemoData.forcedAppearance {
            window.appearance = NSAppearance(named: appearance)
        }
        let controller = PopoverContentController()
        window.contentViewController = controller
        window.setContentSize(NSSize(width: 380, height: 500))
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)

        // After the screen hooks' navigation and scroll have settled.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let view = controller.view
            guard let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else { return }
            view.cacheDisplay(in: view.bounds, to: rep)
            if let png = rep.representation(using: .png, properties: [:]) {
                FileHandle.standardOutput.write(png)
                NSLog("rendered %dx%d", rep.pixelsWide, rep.pixelsHigh)
            }
            NSApp.terminate(nil)
        }
    }
    #endif

    func applicationWillTerminate(_ notification: Notification) {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
}

// MARK: - Popover Content

/// Hosts ContentView over a view that paints the Geist background edge to
/// edge. With `hasFullSizeContent` the popover leaves its arrow to the
/// content, but SwiftUI won't draw outside the safe area, so this view does.
private final class PopoverContentController: NSViewController {
    override func loadView() {
        let background = PopoverBackgroundView()
        let host = NSHostingView(rootView: ContentView())
        host.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(host)

        let safeArea = background.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            host.topAnchor.constraint(equalTo: safeArea.topAnchor),
            host.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            host.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            host.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        view = background
    }
}

#if DEBUG
private final class HiDPIWindow: NSWindow {
    override var backingScaleFactor: CGFloat { 4 }
    // Key, so switches draw in the accent colour as in the active popover.
    override var canBecomeKey: Bool { true }
}
#endif

private final class PopoverBackgroundView: NSView {
    override init(frame: NSRect) {
        super.init(frame: frame)
        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }

    override var wantsUpdateLayer: Bool { true }

    override func updateLayer() {
        let isDark = effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        layer?.backgroundColor = NSColor(GeistColors.background(isDark ? .dark : .light)).cgColor
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
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
