import SwiftUI

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

    private var deploymentList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(store.deployments) { deployment in
                    VStack(spacing: 0) {
                        DeploymentRowView(
                            deployment: deployment,
                            isCurrentProduction: store.currentProductionDeploymentIds.contains(deployment.uid)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelect(deployment)
                        }

                        if deployment.id != store.deployments.last?.id {
                            Divider()
                                .background(GeistColors.border(colorScheme))
                                .padding(.leading, GeistSpacing.md + 20 + GeistSpacing.sm) // Align with text
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
