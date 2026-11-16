import SwiftUI

struct DeploymentRowView: View {
    let deployment: Deployment
    let isCurrentProduction: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    @State private var elapsedTime: String = ""
    @State private var timer: Timer?

    var body: some View {
        HStack(spacing: GeistSpacing.sm) {
            StatusDot(state: deployment.state)
                // As far from the text as from the edge.
                .padding(.trailing, GeistSpacing.md - GeistSpacing.sm)

            // Deployment info
            VStack(alignment: .leading, spacing: 4) {
                // Project name and branch
                HStack(spacing: 8) {
                    Text(deployment.name)
                        .font(GeistFont.medium(GeistFont.body))
                        .foregroundColor(GeistColors.foreground(colorScheme))
                        .lineLimit(1)

                    if let branch = deployment.meta?.githubCommitRef {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.branch")
                                .font(.system(size: 9, weight: .medium))
                            Text(branch)
                                .font(GeistFont.regular(GeistFont.caption))
                        }
                        .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                        .lineLimit(1)
                    }
                }

                // Commit message
                if let commitMessage = deployment.meta?.githubCommitMessage {
                    Text(commitMessage)
                        .font(GeistFont.regular(GeistFont.caption))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                        .lineLimit(1)
                }

                // Time and status
                HStack(spacing: 8) {
                    if deployment.state == .building || deployment.state == .initializing {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(elapsedTime)
                                .font(GeistFont.mono(GeistFont.caption2))
                        }
                        .foregroundColor(GeistColors.warning)
                    } else {
                        Text(timeAgo(from: deployment.createdDate))
                            .font(GeistFont.regular(GeistFont.caption2))
                            .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                    }

                    Text("•")
                        .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                        .font(.system(size: 8))

                    // The dot carries the state's color, as Geist's labels do.
                    Text(deployment.state.displayName)
                        .font(GeistFont.medium(GeistFont.caption2))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                }
            }

            Spacer()

            // The live production deployment, or another production one
            if isCurrentProduction {
                GeistBadge("Current", .greenSubtle)
            } else if deployment.target == "production" {
                GeistBadge("Production", .blueSubtle)
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
        }
        .padding(.horizontal, GeistSpacing.md)
        .padding(.vertical, GeistSpacing.sm)
        .background(isHovered ? GeistColors.backgroundSecondary(colorScheme) : .clear)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .onAppear {
            startTimerIfNeeded()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: deployment.state) { _, newState in
            if newState == .building || newState == .initializing {
                startTimerIfNeeded()
            } else {
                stopTimer()
            }
        }
    }

    private func startTimerIfNeeded() {
        guard deployment.state == .building || deployment.state == .initializing else { return }

        stopTimer()
        updateElapsedTime()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateElapsedTime()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsedTime() {
        let elapsed = Date().timeIntervalSince(deployment.createdDate)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        elapsedTime = String(format: "%d:%02d", minutes, seconds)
    }

    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    VStack(spacing: 0) {
        DeploymentRowView(
            deployment: Deployment(
                uid: "1",
                name: "my-project",
                url: "https://my-project.vercel.app",
                created: Int(Date().timeIntervalSince1970 * 1000),
                state: .building,
                target: "production",
                meta: DeploymentMeta(
                    githubCommitSha: "abc123",
                    githubCommitMessage: "Fix bug in login form",
                    githubCommitRef: "main",
                    githubRepo: "my-project",
                    githubOrg: "myorg"
                ),
                creator: nil,
                inspectorUrl: nil,
                aliasAssigned: false
            ),
            isCurrentProduction: false
        )

        Divider()

        DeploymentRowView(
            deployment: Deployment(
                uid: "2",
                name: "another-project",
                url: "https://another-project.vercel.app",
                created: Int(Date().addingTimeInterval(-3600).timeIntervalSince1970 * 1000),
                state: .ready,
                target: "production",
                meta: DeploymentMeta(
                    githubCommitSha: "def456",
                    githubCommitMessage: "Add new feature",
                    githubCommitRef: "main",
                    githubRepo: "another-project",
                    githubOrg: "myorg"
                ),
                creator: nil,
                inspectorUrl: nil,
                aliasAssigned: true
            ),
            isCurrentProduction: true // This is the current live deployment
        )

        Divider()

        DeploymentRowView(
            deployment: Deployment(
                uid: "3",
                name: "failed-project",
                url: "https://failed-project.vercel.app",
                created: Int(Date().addingTimeInterval(-7200).timeIntervalSince1970 * 1000),
                state: .error,
                target: "production",
                meta: DeploymentMeta(
                    githubCommitSha: "ghi789",
                    githubCommitMessage: "Breaking change that failed the build",
                    githubCommitRef: "main",
                    githubRepo: "failed-project",
                    githubOrg: "myorg"
                ),
                creator: nil,
                inspectorUrl: nil,
                aliasAssigned: false
            ),
            isCurrentProduction: false
        )
    }
    .frame(width: 380)
    .background(Color(nsColor: .windowBackgroundColor))
}
