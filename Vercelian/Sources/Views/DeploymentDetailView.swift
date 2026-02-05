import SwiftUI

struct DeploymentDetailView: View {
    let deployment: Deployment
    let onBack: () -> Void

    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var isPerformingAction = false
    @State private var copiedURL = false

    var body: some View {
        VStack(spacing: 0) {
            // Navigation header
            HStack {
                Button(action: onBack) {
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

                GeistStatusBadge(state: deployment.state)
            }
            .padding(.horizontal, GeistSpacing.md)
            .padding(.vertical, GeistSpacing.sm)

            Divider()
                .background(GeistColors.border(colorScheme))

            ScrollView {
                VStack(alignment: .leading, spacing: GeistSpacing.lg) {
                    // Project info
                    detailSection(title: "Project") {
                        Text(deployment.name)
                            .font(GeistFont.medium(GeistFont.bodyLarge))
                            .foregroundColor(GeistColors.foreground(colorScheme))
                    }

                    // URL with copy button
                    detailSection(title: "URL") {
                        HStack(spacing: GeistSpacing.xs) {
                            Link(destination: URL(string: "https://\(deployment.displayUrl)")!) {
                                Text(deployment.displayUrl)
                                    .font(GeistFont.regular(GeistFont.body))
                                    .lineLimit(1)
                                    .foregroundColor(GeistColors.vercelBlue)
                            }

                            Spacer()

                            Button(action: {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString("https://\(deployment.displayUrl)", forType: .string)
                                withAnimation {
                                    copiedURL = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        copiedURL = false
                                    }
                                }
                            }) {
                                Image(systemName: copiedURL ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 12))
                                    .foregroundColor(copiedURL ? GeistColors.success : GeistColors.foregroundSecondary(colorScheme))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Git info
                    if let meta = deployment.meta {
                        if let branch = meta.githubCommitRef {
                            detailSection(title: "Branch") {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.triangle.branch")
                                        .font(.system(size: 12))
                                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                                    Text(branch)
                                        .font(GeistFont.regular(GeistFont.body))
                                        .foregroundColor(GeistColors.foreground(colorScheme))
                                }
                            }
                        }

                        if let message = meta.githubCommitMessage {
                            detailSection(title: "Commit") {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(message)
                                        .font(GeistFont.regular(GeistFont.body))
                                        .foregroundColor(GeistColors.foreground(colorScheme))
                                        .lineLimit(3)

                                    if let sha = meta.githubCommitSha {
                                        Text(String(sha.prefix(7)))
                                            .font(GeistFont.mono(GeistFont.caption))
                                            .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(GeistColors.backgroundSecondary(colorScheme))
                                            .cornerRadius(GeistRadius.xs)
                                    }
                                }
                            }
                        }

                        if let repo = meta.githubRepo, let org = meta.githubOrg {
                            detailSection(title: "Repository") {
                                Link(destination: URL(string: "https://github.com/\(org)/\(repo)")!) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "link")
                                            .font(.system(size: 11))
                                        Text("\(org)/\(repo)")
                                            .font(GeistFont.regular(GeistFont.body))
                                    }
                                    .foregroundColor(GeistColors.vercelBlue)
                                }
                            }
                        }
                    }

                    // Target
                    detailSection(title: "Environment") {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(deployment.isCurrentProduction ? GeistColors.success : (deployment.isProduction ? GeistColors.vercelBlue : GeistColors.foregroundTertiary(colorScheme)))
                                .frame(width: 8, height: 8)
                            Text(deployment.target?.capitalized ?? "Preview")
                                .font(GeistFont.regular(GeistFont.body))
                                .foregroundColor(GeistColors.foreground(colorScheme))

                            if deployment.isCurrentProduction {
                                Text("Live")
                                    .font(GeistFont.medium(GeistFont.caption2))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(GeistColors.success.opacity(0.1))
                                    .foregroundColor(GeistColors.success)
                                    .cornerRadius(GeistRadius.xs)
                            }
                        }
                    }

                    // Created
                    detailSection(title: "Created") {
                        Text(formatDate(deployment.createdDate))
                            .font(GeistFont.regular(GeistFont.body))
                            .foregroundColor(GeistColors.foreground(colorScheme))
                    }

                    // Actions
                    actionsSection
                }
                .padding(GeistSpacing.md)
            }
        }
    }

    private func detailSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(GeistFont.medium(GeistFont.caption2))
                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                .kerning(0.5)
            content()
        }
    }

    private var actionsSection: some View {
        VStack(spacing: GeistSpacing.sm) {
            Divider()
                .background(GeistColors.border(colorScheme))
                .padding(.vertical, GeistSpacing.xs)

            // Open in browser
            Button(action: {
                if let url = URL(string: "https://\(deployment.displayUrl)") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "safari")
                        .font(.system(size: 13))
                    Text("Open in Browser")
                        .font(GeistFont.medium(GeistFont.body))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, GeistSpacing.xs)
                .background(GeistColors.backgroundSecondary(colorScheme))
                .foregroundColor(GeistColors.foreground(colorScheme))
                .cornerRadius(GeistRadius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: GeistRadius.sm)
                        .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            // View on Vercel
            if let inspectorUrl = deployment.inspectorUrl,
               let url = URL(string: inspectorUrl) {
                Button(action: {
                    NSWorkspace.shared.open(url)
                }) {
                    HStack {
                        Image(systemName: "eye")
                            .font(.system(size: 13))
                        Text("View on Vercel")
                            .font(GeistFont.medium(GeistFont.body))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, GeistSpacing.xs)
                    .background(GeistColors.backgroundSecondary(colorScheme))
                    .foregroundColor(GeistColors.foreground(colorScheme))
                    .cornerRadius(GeistRadius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: GeistRadius.sm)
                            .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: GeistSpacing.sm) {
                // Cancel (if building)
                if deployment.state == .building || deployment.state == .queued || deployment.state == .initializing {
                    Button(action: {
                        cancelDeployment()
                    }) {
                        HStack {
                            if isPerformingAction {
                                ProgressView()
                                    .scaleEffect(0.5)
                                    .frame(width: 14, height: 14)
                            } else {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 13))
                            }
                            Text("Cancel")
                                .font(GeistFont.medium(GeistFont.body))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, GeistSpacing.xs)
                        .background(GeistColors.error.opacity(0.1))
                        .foregroundColor(GeistColors.error)
                        .cornerRadius(GeistRadius.sm)
                    }
                    .buttonStyle(.plain)
                    .disabled(isPerformingAction)
                }

                // Redeploy
                Button(action: {
                    redeploy()
                }) {
                    HStack {
                        if isPerformingAction {
                            ProgressView()
                                .scaleEffect(0.5)
                                .frame(width: 14, height: 14)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 13))
                        }
                        Text("Redeploy")
                            .font(GeistFont.medium(GeistFont.body))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, GeistSpacing.xs)
                    .background(GeistColors.foreground(colorScheme))
                    .foregroundColor(GeistColors.background(colorScheme))
                    .cornerRadius(GeistRadius.sm)
                }
                .buttonStyle(.plain)
                .disabled(isPerformingAction)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func cancelDeployment() {
        isPerformingAction = true
        Task {
            await store.cancelDeployment(deployment)
            isPerformingAction = false
            onBack()
        }
    }

    private func redeploy() {
        isPerformingAction = true
        Task {
            await store.redeployDeployment(deployment)
            isPerformingAction = false
            onBack()
        }
    }
}

#Preview {
    DeploymentDetailView(
        deployment: Deployment(
            uid: "1",
            name: "my-project",
            url: "https://my-project-abc123.vercel.app",
            created: Int(Date().timeIntervalSince1970 * 1000),
            state: .ready,
            target: "production",
            meta: DeploymentMeta(
                githubCommitSha: "abc123def456",
                githubCommitMessage: "Fix critical bug in login form that was preventing users from signing in",
                githubCommitRef: "main",
                githubRepo: "my-project",
                githubOrg: "myorg"
            ),
            creator: nil,
            inspectorUrl: "https://vercel.com/myorg/my-project/abc123",
            aliasAssigned: true
        ),
        onBack: {}
    )
    .frame(width: 380, height: 500)
}
