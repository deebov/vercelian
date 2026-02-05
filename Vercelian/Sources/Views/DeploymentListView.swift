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

// MARK: - Swipeable Row

struct SwipeableRow<Content: View>: View {
    let content: Content
    let actions: [SwipeAction]

    @State private var offset: CGFloat = 0
    @State private var isRevealed = false
    @Environment(\.colorScheme) var colorScheme

    private let actionButtonWidth: CGFloat = 64
    private var totalActionsWidth: CGFloat { CGFloat(actions.count) * actionButtonWidth }

    init(actions: [SwipeAction], @ViewBuilder content: () -> Content) {
        self.actions = actions
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons behind
            HStack(spacing: 0) {
                ForEach(actions) { action in
                    swipeActionButton(action: action)
                }
            }
            .frame(width: totalActionsWidth)

            // Main content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture(minimumDistance: 15)
                        .onChanged { value in
                            let horizontal = value.translation.width
                            // Only allow swipe left (negative), or swipe right to close
                            if isRevealed {
                                offset = min(0, max(-totalActionsWidth, -totalActionsWidth + horizontal))
                            } else {
                                offset = min(0, horizontal)
                            }
                        }
                        .onEnded { value in
                            let threshold = totalActionsWidth * 0.4
                            if isRevealed {
                                // If already open, close if swiped right enough
                                if value.translation.width > threshold {
                                    close()
                                } else {
                                    open()
                                }
                            } else {
                                // Open if swiped left enough
                                if -value.translation.width > threshold || -value.velocity.width > 500 {
                                    open()
                                } else {
                                    close()
                                }
                            }
                        }
                )
        }
        .clipped()
    }

    private func open() {
        withAnimation(.easeOut(duration: 0.2)) {
            offset = -totalActionsWidth
            isRevealed = true
        }
    }

    private func close() {
        withAnimation(.easeOut(duration: 0.2)) {
            offset = 0
            isRevealed = false
        }
    }

    private func swipeActionButton(action: SwipeAction) -> some View {
        Button {
            close()
            action.action()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: action.icon)
                    .font(.system(size: 14, weight: .medium))
                Text(action.title)
                    .font(GeistFont.medium(GeistFont.caption2))
            }
            .foregroundColor(.white)
            .frame(width: actionButtonWidth)
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
                        SwipeableRow(actions: swipeActions(for: deployment)) {
                            DeploymentRowView(
                                deployment: deployment,
                                isCurrentProduction: store.currentProductionDeploymentIds.contains(deployment.uid)
                            )
                            .background(GeistColors.background(colorScheme))
                            .contentShape(Rectangle())
                            .onTapGesture {
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
