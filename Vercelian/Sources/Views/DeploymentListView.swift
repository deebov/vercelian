import SwiftUI
import AppKit

// MARK: - Swipe Action Button

struct SwipeAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
}

// MARK: - Row Swipe Manager (shared state for trackpad-driven row swiping)

final class RowSwipeManager: ObservableObject {
    static let shared = RowSwipeManager()

    @Published var activeRowId: String?
    @Published var swipeOffset: CGFloat = 0
    @Published var closingRowId: String?
    @Published var closingOffset: CGFloat = 0

    private var hoveredRowId: String?
    private var isRevealed = false
    private var maxReveal: CGFloat = 192 // 3 actions * 64
    private var rawOffset: CGFloat = 0 // unbounded logical offset, tracks actual finger movement

    func setHovered(_ rowId: String?) {
        hoveredRowId = rowId
    }

    func setMaxReveal(_ width: CGFloat) {
        maxReveal = width
    }

    func handleScroll(delta: CGFloat, phase: NSEvent.Phase) {
        switch phase {
        case .began:
            // If swiping on a different row, animate old one closed
            if let hovered = hoveredRowId, hovered != activeRowId {
                if let oldRow = activeRowId {
                    // Capture current offset and set up closing state
                    closingRowId = oldRow
                    closingOffset = swipeOffset

                    // Switch to the new row immediately
                    activeRowId = hovered
                    swipeOffset = 0
                    rawOffset = 0
                    isRevealed = false

                    // Animate close on next frame so SwiftUI sees the starting value first
                    DispatchQueue.main.async { [weak self] in
                        withAnimation(.easeOut(duration: 0.15)) {
                            self?.closingOffset = 0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                        if self?.closingRowId == oldRow {
                            self?.closingRowId = nil
                            self?.closingOffset = 0
                        }
                    }
                } else {
                    swipeOffset = 0
                    rawOffset = 0
                    isRevealed = false
                    activeRowId = hovered
                }
            } else if activeRowId == nil {
                activeRowId = hoveredRowId
                rawOffset = isRevealed ? -maxReveal : 0
            }

        case .changed:
            guard activeRowId != nil else { return }
            // Accumulate into unbounded raw offset (capped at 0 — can't swipe right past origin)
            rawOffset = min(0, rawOffset + delta)

            // Apply rubber band for the visual offset beyond maxReveal
            if rawOffset < -maxReveal {
                let overscroll = -rawOffset - maxReveal
                let c: CGFloat = 0.3
                let dim = maxReveal
                let rubberBanded = overscroll * c / (1 + overscroll * c / dim)
                swipeOffset = -(maxReveal + rubberBanded)
            } else {
                swipeOffset = rawOffset
            }

        case .ended, .cancelled:
            guard activeRowId != nil else { return }
            let threshold = maxReveal * 0.35
            if -swipeOffset > threshold {
                // Snap to open position, spring back from any overscroll
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    swipeOffset = -maxReveal
                }
                rawOffset = -maxReveal
                isRevealed = true
            } else {
                // Snap closed
                close()
            }

        default:
            break
        }
    }

    #if DEBUG
    /// Screenshot tooling (see DemoData): leave a row's actions open, as a
    /// completed swipe does.
    func reveal(_ rowId: String, width: CGFloat) {
        maxReveal = width
        rawOffset = -width
        swipeOffset = -width
        isRevealed = true
        activeRowId = rowId
    }
    #endif

    func close() {
        let closingRowId = activeRowId
        rawOffset = 0
        withAnimation(.easeOut(duration: 0.2)) {
            swipeOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            if self.activeRowId == closingRowId {
                self.activeRowId = nil
                self.isRevealed = false
            }
        }
    }
}

// MARK: - Swipeable Row

struct SwipeableRow<Content: View>: View {
    let rowId: String
    let content: Content
    let actions: [SwipeAction]

    @ObservedObject private var manager = RowSwipeManager.shared
    @Environment(\.colorScheme) var colorScheme

    private let minButtonWidth: CGFloat = 72
    private let maxActionWidth: CGFloat = 72

    init(rowId: String, actions: [SwipeAction], @ViewBuilder content: () -> Content) {
        self.rowId = rowId
        self.actions = actions
        self.content = content()
    }

    private var isActive: Bool {
        manager.activeRowId == rowId
    }

    private var isClosing: Bool {
        manager.closingRowId == rowId
    }

    private var currentOffset: CGFloat {
        if isActive { return manager.swipeOffset }
        if isClosing { return manager.closingOffset }
        return 0
    }

    private var revealedWidth: CGFloat {
        abs(min(currentOffset, 0))
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons - deck of cards layout
            if revealedWidth > 0 {
                ZStack(alignment: .leading) {
                    let count = CGFloat(actions.count)
                    let cardWidth = max(minButtonWidth, revealedWidth / count)
                    ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                        let i = CGFloat(index)
                        let cardX = revealedWidth * (i / count)
                        swipeActionButton(action: action, width: cardWidth)
                            .offset(x: cardX)
                            .zIndex(Double(index))
                    }
                }
                .frame(width: revealedWidth, alignment: .leading)
            }

            // Main content
            content
                .offset(x: currentOffset)
        }
        .clipped()
        .onHover { hovering in
            if hovering {
                manager.setHovered(rowId)
                manager.setMaxReveal(CGFloat(actions.count) * maxActionWidth)
            }
        }
        #if DEBUG
        .onAppear {
            // Screenshot tooling (see DemoData).
            if rowId == DemoData.swipedRowId {
                manager.reveal(rowId, width: CGFloat(actions.count) * maxActionWidth)
            }
        }
        #endif
    }

    private func swipeActionButton(action: SwipeAction, width: CGFloat) -> some View {
        Button {
            manager.close()
            action.action()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: action.icon)
                    .font(.system(size: 14, weight: .medium))
                Text(action.title)
                    .font(GeistFont.medium(GeistFont.caption2))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .foregroundColor(.white)
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .background(action.color)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Deployment List View

struct DeploymentListView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    var onSelect: (Deployment) -> Void

    var body: some View {
        Group {
            if store.isLoading && store.deployments.isEmpty {
                loadingView
            } else if store.deployments.isEmpty, let error = store.error {
                errorView(error)
            } else if store.deployments.isEmpty {
                emptyView
            } else {
                deploymentList
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: GeistSpacing.md) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading deployments...")
                .font(GeistFont.regular(GeistFont.body))
                .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: GeistSpacing.sm) {
            ZStack {
                Circle()
                    .fill(GeistColors.backgroundSecondary(colorScheme))
                    .frame(width: 56, height: 56)

                Image(systemName: "shippingbox")
                    .font(.system(size: 24))
                    .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            }

            Text("No deployments")
                .font(GeistFont.medium(GeistFont.body))
                .foregroundColor(GeistColors.foreground(colorScheme))

            if store.selectedProject != nil {
                Text("for this project")
                    .font(GeistFont.regular(GeistFont.caption))
                    .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Nothing loaded and the last request failed. Without this a failed
    /// load looked identical to an account with no deployments.
    private func errorView(_ message: String) -> some View {
        VStack(spacing: GeistSpacing.sm) {
            ZStack {
                Circle()
                    .fill(GeistColors.backgroundSecondary(colorScheme))
                    .frame(width: 56, height: 56)

                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 22))
                    .foregroundColor(GeistColors.error)
            }

            Text("Couldn't load deployments")
                .font(GeistFont.medium(GeistFont.body))
                .foregroundColor(GeistColors.foreground(colorScheme))

            Text(message)
                .font(GeistFont.regular(GeistFont.caption))
                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, GeistSpacing.xl)

            Button("Try again") {
                Task { await store.refresh() }
            }
            .buttonStyle(GeistButtonStyle(variant: .secondary))
            .padding(.top, GeistSpacing.xs)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Deployments are on screen but the last request failed: a refresh
    /// (so the list may be stale) or a cancel/redeploy.
    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 11))
            Text(message)
                .font(GeistFont.regular(GeistFont.caption))
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .foregroundColor(GeistColors.error)
        .padding(.horizontal, GeistSpacing.md)
        .padding(.vertical, GeistSpacing.xs)
        .background(GeistColors.error.opacity(0.08))
    }

    /// Loads the next page when the end of the list comes into view, and
    /// again after each page while it stays in view. A failed load waits
    /// for a click rather than retrying on every scroll.
    private var loadMoreFooter: some View {
        Group {
            if store.loadMoreFailed && !store.isLoadingMore {
                Button("Load more") {
                    Task { await store.loadMoreDeployments() }
                }
                .buttonStyle(GeistButtonStyle(variant: .secondary))
            } else {
                ProgressView()
                    .controlSize(.small)
                    .task(id: store.deployments.count) {
                        // A task of its own, so scrolling away doesn't cancel
                        // the request and report it as failed.
                        await Task { await store.loadMoreDeployments() }.value
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, GeistSpacing.sm)
    }

    private func swipeActions(for deployment: Deployment) -> [SwipeAction] {
        var actions: [SwipeAction] = []

        actions.append(SwipeAction(
            title: "Visit",
            icon: "safari",
            color: GeistColors.vercelBlue,
            action: {
                if let url = URL(string: "https://\(deployment.displayUrl)") {
                    NSWorkspace.shared.open(url)
                }
            }
        ))

        if let inspectorUrl = deployment.inspectorUrl, let url = URL(string: inspectorUrl) {
            actions.append(SwipeAction(
                title: "Deployment",
                icon: "arrow.up.right.square",
                color: Color(hex: "555555"),
                action: {
                    NSWorkspace.shared.open(url)
                }
            ))

            let logsUrl = URL(string: inspectorUrl + "/logs")!
            actions.append(SwipeAction(
                title: "Logs",
                icon: "text.alignleft",
                color: Color(hex: "6E56CF"),
                action: {
                    NSWorkspace.shared.open(logsUrl)
                }
            ))
        }

        return actions
    }

    private var deploymentList: some View {
        VStack(spacing: 0) {
            if let error = store.error {
                errorBanner(error)
            }

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.deployments) { deployment in
                        VStack(spacing: 0) {
                            SwipeableRow(rowId: deployment.uid, actions: swipeActions(for: deployment)) {
                                DeploymentRowView(
                                    deployment: deployment,
                                    isCurrentProduction: store.currentProductionDeploymentIds.contains(deployment.uid)
                                )
                                .background(GeistColors.background(colorScheme))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    RowSwipeManager.shared.close()
                                    onSelect(deployment)
                                }
                            }

                            if deployment.id != store.deployments.last?.id {
                                GeistDivider()
                                    .padding(.leading, GeistSpacing.md + 10 + GeistSpacing.md)
                            }
                        }
                    }

                    if store.hasMoreDeployments {
                        loadMoreFooter
                    }
                }
                .padding(.vertical, GeistSpacing.xs)
            }
            #if DEBUG
            // Screenshot tooling (see DemoData).
            .defaultScrollAnchor(DemoData.scrollAnchor)
            #endif
        }
    }
}

#Preview {
    DeploymentListView(onSelect: { _ in })
}
