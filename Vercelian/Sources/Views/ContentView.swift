import SwiftUI

struct ContentView: View {
    @StateObject private var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            if store.isAuthenticated {
                MainView(showSettings: $showSettings)
            } else {
                LoginView()
            }
        }
        .frame(width: 380, height: 500)
        .background(GeistColors.background(colorScheme))
    }
}

enum NavigationDestination: Equatable {
    case list
    case detail(Deployment)
    case settings

    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.list, .list): return true
        case (.settings, .settings): return true
        case (.detail(let d1), .detail(let d2)): return d1.uid == d2.uid
        default: return false
        }
    }
}

// MARK: - Trackpad Swipe Detection

final class SwipeEventMonitor: ObservableObject {
    var onSwipe: ((CGFloat, NSEvent.Phase) -> Void)?
    var onRowSwipe: ((CGFloat, NSEvent.Phase) -> Void)?
    var isOnListPage: (() -> Bool)?
    private var monitor: Any?
    private var isTracking = false
    private var isHorizontalGesture = false
    private var consumeMomentum = false

    func start() {
        guard monitor == nil else { return }
        monitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] event in
            guard let self = self else { return event }

            // Handle momentum events: consume them silently if the gesture was horizontal
            if event.momentumPhase != [] {
                if self.consumeMomentum {
                    if event.momentumPhase == .ended {
                        self.consumeMomentum = false
                    }
                    return nil
                }
                return event
            }

            // Only process direct finger contact (event.phase)
            guard event.phase != [] else { return event }
            let phase = event.phase

            if phase == .began {
                self.isTracking = true
                self.consumeMomentum = false
                self.isHorizontalGesture = abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY)
            }

            if phase == .ended || phase == .cancelled {
                let wasHorizontal = self.isHorizontalGesture
                self.isTracking = false
                self.isHorizontalGesture = false
                if wasHorizontal {
                    self.consumeMomentum = true
                    if self.isOnListPage?() == true {
                        self.onRowSwipe?(event.scrollingDeltaX, phase)
                    } else {
                        self.onSwipe?(event.scrollingDeltaX, phase)
                    }
                    return nil
                }
                return event
            }

            if self.isTracking && self.isHorizontalGesture {
                if self.isOnListPage?() == true {
                    self.onRowSwipe?(event.scrollingDeltaX, phase)
                } else {
                    self.onSwipe?(event.scrollingDeltaX, phase)
                }
                return nil
            }

            return event
        }
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }

    deinit {
        stop()
    }
}

struct MainView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSettings: Bool
    @State private var currentDestination: NavigationDestination = .list
    @State private var swipeOffset: CGFloat = 0
    @State private var isSwiping = false
    @State private var lastDetail: Deployment?
    @StateObject private var swipeMonitor = SwipeEventMonitor()
    // Static flag so the event monitor closure can read current state
    static var _isOnListPage = true

    private let viewWidth: CGFloat = 380

    /// 0 = list visible, 1 = detail/settings fully visible
    private var detailProgress: CGFloat {
        if currentDestination == .settings {
            return 0
        }
        if currentDestination == .list && !isSwiping {
            return 0
        }
        if currentDestination != .list {
            // swipeOffset goes from viewWidth (entering) to 0 (fully visible)
            // During swipe-back it goes from 0 to viewWidth
            let progress = 1 - (swipeOffset / viewWidth)
            return max(0, min(1, progress))
        }
        // Swiping out from detail back to list
        return max(0, min(1, 1 - (swipeOffset / viewWidth)))
    }

    private var activeDeployment: Deployment? {
        if case .detail(let d) = currentDestination { return d }
        return lastDetail
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(
                showSettings: currentDestination == .settings,
                onSettingsTap: {
                    if currentDestination == .settings {
                        navigateBack()
                    } else {
                        navigateForward(.settings)
                    }
                }
            )

            GeistDivider()

            if currentDestination == .settings {
                // Settings transition: move list sub-header + list content as one stack.
                GeometryReader { geo in
                    ZStack {
                        VStack(spacing: 0) {
                            subHeader
                            GeistDivider()
                            listContent
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        .offset(x: settingsListOffset)
                        .allowsHitTesting(false)

                        if showsOverlay {
                            overlayView
                                .frame(width: geo.size.width, height: geo.size.height)
                                .background(GeistColors.background(colorScheme))
                                .offset(x: overlayOffset)
                        }
                    }
                }
                .clipped()
            } else {
                subHeader

                GeistDivider()

                GeometryReader { geo in
                    ZStack {
                        // List is always rendered behind
                        listContent
                            .frame(width: geo.size.width, height: geo.size.height)
                            .offset(x: listOffset)

                        // Overlay page (detail or settings) on top
                        if showsOverlay {
                            overlayView
                                .frame(width: geo.size.width, height: geo.size.height)
                                .background(GeistColors.background(colorScheme))
                                .offset(x: overlayOffset)
                        }
                    }
                }
                .clipped()
            }
        }
        .background(GeistColors.background(colorScheme))
        .onAppear {
            swipeMonitor.onSwipe = { [self] delta, phase in
                handleSwipe(delta: delta, phase: phase)
            }
            swipeMonitor.onRowSwipe = { delta, phase in
                RowSwipeManager.shared.handleScroll(delta: delta, phase: phase)
            }
            swipeMonitor.isOnListPage = {
                MainView._isOnListPage
            }
            swipeMonitor.start()

            #if DEBUG
            // Screenshot tooling (see DemoData): start on a given screen.
            switch DemoData.initialScreen {
            case "settings":
                navigateForward(.settings)
            case "detail":
                let building = store.deployments.first { $0.state == .building }
                if let deployment = building ?? store.deployments.first {
                    navigateForward(.detail(deployment))
                }
            default:
                break
            }
            #endif
        }
        .onDisappear {
            swipeMonitor.stop()
        }
    }

    private var listOffset: CGFloat {
        if currentDestination == .list && !isSwiping {
            return 0
        }
        let clamped = min(swipeOffset, viewWidth)
        let parallax = viewWidth / 3
        return -parallax + (clamped / viewWidth) * parallax
    }

    private var settingsListOffset: CGFloat {
        -(viewWidth - swipeOffset)
    }

    private var overlayOffset: CGFloat {
        if currentDestination == .list && !isSwiping {
            return viewWidth
        }
        return swipeOffset
    }

    private var showsOverlay: Bool {
        currentDestination != .list || isSwiping
    }

    @ViewBuilder
    private var overlayView: some View {
        switch currentDestination {
        case .detail(let deployment):
            DeploymentDetailView(deployment: deployment, onBack: {
                navigateBack()
            })
        case .settings:
            SettingsView(showSettings: .constant(true))
        case .list:
            // Show last detail during swipe-out animation
            if let dep = lastDetail {
                DeploymentDetailView(deployment: dep, onBack: {})
            }
        }
    }

    @ViewBuilder
    private var subHeader: some View {
        ZStack {
            // List filters — visible when on list
            ProjectSelectorView()
                .opacity(1 - detailProgress)
                .allowsHitTesting(detailProgress < 0.5)

            // Detail header: back button + status badge
            HStack {
                Button(action: { navigateBack() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Back")
                            .font(GeistFont.medium(GeistFont.body))
                    }
                    .foregroundColor(GeistColors.foreground(colorScheme))
                }
                .buttonStyle(.plain)

                Spacer()

                if let deployment = activeDeployment {
                    StatusLabel(state: deployment.state)
                }
            }
            .padding(.horizontal, GeistSpacing.md)
            .frame(height: 40)
            .opacity(detailProgress)
            .allowsHitTesting(detailProgress >= 0.5)
        }
        .frame(height: 40)
    }

    private var listContent: some View {
        DeploymentListView(onSelect: { deployment in
            navigateForward(.detail(deployment))
        })
    }

    private func navigateForward(_ destination: NavigationDestination) {
        if case .detail(let d) = destination {
            lastDetail = d
        }
        // Start off-screen right, animate in
        swipeOffset = viewWidth
        currentDestination = destination
        Self._isOnListPage = false
        withAnimation(.easeOut(duration: 0.25)) {
            swipeOffset = 0
        }
    }

    private func navigateBack() {
        if case .detail(let d) = currentDestination {
            lastDetail = d
        }
        withAnimation(.easeOut(duration: 0.25)) {
            swipeOffset = viewWidth
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            currentDestination = .list
            Self._isOnListPage = true
            swipeOffset = 0
            isSwiping = false
        }
    }

    @State private var swipeCompleted = false

    private func handleSwipe(delta: CGFloat, phase: NSEvent.Phase) {
        guard currentDestination != .list, !swipeCompleted else { return }

        switch phase {
        case .began:
            isSwiping = true
            swipeCompleted = false

        case .changed:
            isSwiping = true
            swipeOffset = min(max(0, swipeOffset + delta), viewWidth)

        case .ended, .cancelled:
            if swipeOffset > viewWidth * 0.35 {
                swipeCompleted = true
                if case .detail(let d) = currentDestination {
                    lastDetail = d
                }
                withAnimation(.easeOut(duration: 0.2)) {
                    swipeOffset = viewWidth
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    currentDestination = .list
                    Self._isOnListPage = true
                    swipeOffset = 0
                    isSwiping = false
                    swipeCompleted = false
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    swipeOffset = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isSwiping = false
                }
            }

        default:
            break
        }
    }
}

struct HeaderView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    var showSettings: Bool
    var onSettingsTap: () -> Void
    @State private var isManualRefreshing = false
    @State private var refreshHovered = false
    @State private var settingsHovered = false

    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 10) {
                // Wordmark logo
                Image("VercelianWordmark")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 14)
                    .foregroundColor(GeistColors.foreground(colorScheme))

                if isManualRefreshing {
                    ProgressView()
                        .controlSize(.small)
                        .scaleEffect(0.62)
                        .frame(width: 10, height: 14, alignment: .center)
                        .offset(y: 0.5)
                        .tint(GeistColors.foregroundTertiary(colorScheme))
                }
            }

            Spacer()

            // Refresh button
            Button(action: {
                guard !isManualRefreshing else { return }
                isManualRefreshing = true
                Task {
                    defer {
                        Task { @MainActor in
                            isManualRefreshing = false
                        }
                    }
                    await store.refresh()
                }
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                    .frame(width: 28, height: 28)
                    .background(refreshHovered ? GeistColors.backgroundSecondary(colorScheme) : .clear)
                    .cornerRadius(GeistRadius.sm)
            }
            .buttonStyle(.plain)
            .disabled(isManualRefreshing)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    refreshHovered = hovering
                }
            }

            // Settings button
            Button(action: onSettingsTap) {
                Image(systemName: showSettings ? "xmark" : "gearshape")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                    .frame(width: 28, height: 28)
                    .background(settingsHovered ? GeistColors.backgroundSecondary(colorScheme) : .clear)
                    .cornerRadius(GeistRadius.sm)
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    settingsHovered = hovering
                }
            }
        }
        .padding(.leading, GeistSpacing.md)
        // The gear's glyph, not its button, lines up with the edge of the
        // content below.
        .padding(.trailing, GeistSpacing.md - Self.glyphInset)
        .padding(.vertical, GeistSpacing.sm)
    }

    /// How far the gear's glyph sits inside its 28-point button, less the
    /// rows' chevron margin, so the two right edges meet.
    static let glyphInset: CGFloat = 6
}

#Preview {
    ContentView()
}
