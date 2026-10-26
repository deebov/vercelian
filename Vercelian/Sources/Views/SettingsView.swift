import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var store = DeploymentStore.shared
    @ObservedObject var settings = SettingsManager.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSettings: Bool
    @State private var showLogoutConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GeistSpacing.lg) {
                // User info section
                if let user = store.currentUser {
                    userSection(user: user)
                }

                // Team selection
                teamSection

                // Notifications section
                notificationsSection

                // Appearance section
                appearanceSection

                // About section
                aboutSection

                // Logout button
                logoutSection
            }
            .padding(GeistSpacing.md)
        }
        .alert("Sign out", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Sign out", role: .destructive) {
                store.logout()
            }
        } message: {
            Text("Are you sure you want to sign out? Your access token will be removed from Keychain.")
        }
    }

    private func userSection(user: User) -> some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("Account")

            HStack(spacing: GeistSpacing.sm) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(GeistColors.foreground(colorScheme))
                        .frame(width: 40, height: 40)

                    Text(user.displayName.prefix(1).uppercased())
                        .font(GeistFont.semibold(GeistFont.title3))
                        .foregroundColor(GeistColors.background(colorScheme))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(user.displayName)
                        .font(GeistFont.medium(GeistFont.bodyLarge))
                        .foregroundColor(GeistColors.foreground(colorScheme))
                    Text(user.email)
                        .font(GeistFont.regular(GeistFont.footnote))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                }

                Spacer()
            }
            .padding(GeistSpacing.sm)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
        }
    }

    private var teamSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("Team")

            VStack(alignment: .leading, spacing: GeistSpacing.xs) {
                Text("Select the team to monitor deployments from:")
                    .font(GeistFont.regular(GeistFont.footnote))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))

                HStack {
                    Text("Team")
                        .font(GeistFont.regular(GeistFont.body))
                        .foregroundColor(GeistColors.foreground(colorScheme))
                    Spacer()
                    Picker("", selection: Binding(
                        get: { store.selectedTeam?.id ?? "personal" },
                        set: { newValue in
                            if newValue == "personal" {
                                store.selectTeam(nil)
                            } else if let team = store.teams.first(where: { $0.id == newValue }) {
                                store.selectTeam(team)
                            }
                        }
                    )) {
                        Text("Personal account").tag("personal")

                        if !store.teams.isEmpty {
                            Divider()
                            ForEach(store.teams) { team in
                                Text(team.displayName).tag(team.id)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 200)
                }
            }
            .padding(GeistSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
        }
    }

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("Notifications")

            VStack(alignment: .leading, spacing: 0) {
                settingsToggle(
                    icon: "bell.fill",
                    title: "Enable notifications",
                    isOn: $settings.notificationsEnabled
                )

                if settings.notificationsEnabled {
                    Divider()
                        .background(GeistColors.border(colorScheme))
                        .padding(.horizontal, GeistSpacing.sm)

                    settingsToggle(
                        icon: nil,
                        title: "Notify on failed deployments",
                        isOn: $settings.notifyOnFailure,
                        iconColor: GeistColors.error
                    )

                    Divider()
                        .background(GeistColors.border(colorScheme))
                        .padding(.horizontal, GeistSpacing.sm)

                    settingsToggle(
                        icon: nil,
                        title: "Notify on successful deployments",
                        isOn: $settings.notifyOnSuccess,
                        iconColor: GeistColors.success
                    )
                }

                if !notificationManager.isAuthorized {
                    Divider()
                        .background(GeistColors.border(colorScheme))
                        .padding(.horizontal, GeistSpacing.sm)

                    Button(action: {
                        Task {
                            _ = await notificationManager.requestAuthorization()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 12))
                                .foregroundColor(GeistColors.warning)
                            Text("Grant notification permission")
                                .font(GeistFont.regular(GeistFont.footnote))
                                .foregroundColor(GeistColors.foreground(colorScheme))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(GeistSpacing.sm)
                }
            }
            .frame(maxWidth: .infinity)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
        }
    }

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("Appearance")

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        Image(systemName: "menubar.rectangle")
                            .font(.system(size: 12))
                            .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Dynamic menu bar icon")
                                .font(GeistFont.regular(GeistFont.body))
                                .foregroundColor(GeistColors.foreground(colorScheme))
                            Text("Icon changes color when building or on error")
                                .font(GeistFont.regular(GeistFont.caption))
                                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                        }
                    }
                    Spacer()
                    Toggle("", isOn: $settings.dynamicMenuBarIcon)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                .padding(GeistSpacing.sm)
            }
            .frame(maxWidth: .infinity)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("About")

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Vercelian")
                        .font(GeistFont.medium(GeistFont.bodyLarge))
                        .foregroundColor(GeistColors.foreground(colorScheme))
                    Spacer()
                    Text("v\(appVersion)")
                        .font(GeistFont.mono(GeistFont.footnote))
                        .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                }
                .padding(GeistSpacing.sm)

                Divider()
                    .background(GeistColors.border(colorScheme))
                    .padding(.horizontal, GeistSpacing.sm)

                linkRow(
                    icon: "star",
                    title: "Star on GitHub",
                    url: "https://github.com/deebov/vercelian"
                )

                Divider()
                    .background(GeistColors.border(colorScheme))
                    .padding(.horizontal, GeistSpacing.sm)

                linkRow(
                    icon: "exclamationmark.bubble",
                    title: "Report an issue",
                    url: "https://github.com/deebov/vercelian/issues"
                )
            }
            .frame(maxWidth: .infinity)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
        }
    }

    private var logoutSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            Button(action: {
                showLogoutConfirmation = true
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 13))
                    Text("Sign out")
                        .font(GeistFont.medium(GeistFont.body))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, GeistSpacing.xs)
                .background(GeistColors.error.opacity(0.1))
                .foregroundColor(GeistColors.error)
                .cornerRadius(GeistRadius.sm)
            }
            .buttonStyle(.plain)

            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Image(systemName: "power")
                        .font(.system(size: 12, weight: .medium))
                    Text("Quit Vercelian")
                        .font(GeistFont.medium(GeistFont.body))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, GeistSpacing.xs)
                .background(GeistColors.backgroundSecondary(colorScheme))
                .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                .cornerRadius(GeistRadius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: GeistRadius.sm)
                        .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            Text("Your access token is stored securely in macOS Keychain and will be removed when you sign out.")
                .font(GeistFont.regular(GeistFont.caption))
                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }

    // MARK: - Helper Views

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(GeistFont.medium(GeistFont.caption2))
            .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            .kerning(0.5)
    }

    private func settingsToggle(
        icon: String?,
        title: String,
        isOn: Binding<Bool>,
        iconColor: Color? = nil
    ) -> some View {
        HStack {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                } else if let color = iconColor {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
                Text(title)
                    .font(GeistFont.regular(GeistFont.body))
                    .foregroundColor(GeistColors.foreground(colorScheme))
            }
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding(GeistSpacing.sm)
    }

    private func linkRow(icon: String, title: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                Text(title)
                    .font(GeistFont.regular(GeistFont.body))
                    .foregroundColor(GeistColors.foreground(colorScheme))
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10))
                    .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            }
            .padding(GeistSpacing.sm)
        }
    }
}

#Preview {
    SettingsView(showSettings: .constant(true))
        .frame(width: 380, height: 500)
}
