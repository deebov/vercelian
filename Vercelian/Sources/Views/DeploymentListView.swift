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

    private var hoveredRowId: String?
    private var isRevealed = false
    private var maxReveal: CGFloat = 192 // 3 actions * 64

    func setHovered(_ rowId: String?) {
        hoveredRowId = rowId
    }

    func setMaxReveal(_ width: CGFloat) {
        maxReveal = width
    }

    func handleScroll(delta: CGFloat, phase: NSEvent.Phase) {
        switch phase {
        case .began:
            // If swiping on a different row, close the old one first
            if let hovered = hoveredRowId, hovered != activeRowId {
                if activeRowId != nil {
                    close()
                }
                activeRowId = hovered
            } else if activeRowId == nil {
                activeRowId = hoveredRowId
            }

        case .changed:
            guard activeRowId != nil else { return }
            let raw: CGFloat
            if isRevealed {
                raw = swipeOffset + delta
            } else {
                raw = min(0, swipeOffset + delta)
            }
            // Native-style rubber band beyond maxReveal
            if raw < -maxReveal {
                let overscroll = -raw - maxReveal
                // Apple's rubber band formula: x = d * (1 - 1/((d*c/dim)+1))
                let c: CGFloat = 0.55
                let dim = maxReveal
                let rubberBanded = overscroll * c / (1 + overscroll * c / dim)
                swipeOffset = -(maxReveal + rubberBanded)
            } else {
                swipeOffset = max(-maxReveal, raw)
            }

        case .ended, .cancelled:
            guard activeRowId != nil else { return }
            let threshold = maxReveal * 0.35
            if -swipeOffset > threshold {
                // Snap open with spring (bounces back from elastic overscroll)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    swipeOffset = -maxReveal
                }
                isRevealed = true
            } else {
                // Snap closed
                close()
            }

        default:
            break
        }
    }

    func close() {
        withAnimation(.easeOut(duration: 0.2)) {
            swipeOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.activeRowId = nil
            self?.isRevealed = false
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

    private var currentOffset: CGFloat {
        isActive ? manager.swipeOffset : 0
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

    private func swipeActions(for deployment: Deployment) -> [SwipeAction] {
        var actions: [SwipeAction] = []

        actions.append(SwipeAction(
            title: "Open",
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
                title: "Vercel",
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
                            Divider()
                                .background(GeistColors.border(colorScheme))
                                .padding(.leading, GeistSpacing.md + 20 + GeistSpacing.sm)
                        }
                    }
                }
            }
            .padding(.vertical, GeistSpacing.xs)
        }
    }
}

#Preview {
    DeploymentListView(onSelect: { _ in })
}
