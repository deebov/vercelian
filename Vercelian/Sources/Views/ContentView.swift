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

struct MainView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSettings: Bool
    @State private var currentDestination: NavigationDestination = .list
    @State private var slideDirection: SlideDirection = .forward

    enum SlideDirection {
        case forward, backward
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(
                showSettings: currentDestination == .settings,
                onSettingsTap: {
                    if currentDestination == .settings {
                        navigateTo(.list, direction: .backward)
                    } else {
                        navigateTo(.settings, direction: .forward)
                    }
                }
            )

            Divider()
                .background(GeistColors.border(colorScheme))

            // Content with transitions
            ZStack {
                switch currentDestination {
                case .list:
                    listContent
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))

                case .detail(let deployment):
                    DeploymentDetailView(deployment: deployment, onBack: {
                        navigateTo(.list, direction: .backward)
                    })
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))

                case .settings:
                    SettingsView(showSettings: .constant(true))
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)
                        ))
                }
            }
            .clipped()
            .animation(.easeInOut(duration: 0.25), value: currentDestination)
        }
        .background(GeistColors.background(colorScheme))
    }

    private var listContent: some View {
        VStack(spacing: 0) {
            // Project selector
            ProjectSelectorView()

            Divider()
                .background(GeistColors.border(colorScheme))

            // Deployment list
            DeploymentListView(onSelect: { deployment in
                navigateTo(.detail(deployment), direction: .forward)
            })
        }
    }

    private func navigateTo(_ destination: NavigationDestination, direction: SlideDirection) {
        slideDirection = direction
        withAnimation(.easeInOut(duration: 0.25)) {
            currentDestination = destination
        }
    }
}

struct HeaderView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme
    var showSettings: Bool
    var onSettingsTap: () -> Void
    @State private var refreshHovered = false
    @State private var settingsHovered = false

    var body: some View {
        HStack {
            // Vercel logo / title
            HStack(spacing: 8) {
                VercelLogo(size: 18)
                Text("Vercelian")
                    .font(GeistFont.semibold(GeistFont.title3))
                    .foregroundColor(GeistColors.foreground(colorScheme))
            }

            Spacer()

            // Refresh button
            Button(action: {
                Task {
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
            .disabled(store.isLoading)
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
        .padding(.horizontal, GeistSpacing.md)
        .padding(.vertical, GeistSpacing.sm)
    }
}

#Preview {
    ContentView()
}
