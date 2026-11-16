import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var store = DeploymentStore.shared
    @ObservedObject var settings = SettingsManager.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSettings: Bool
    @State private var showLogoutConfirmation = false

    /// Row icons and dots sit centered in a column this wide, so the titles
    /// beside them line up.
    private static let iconColumnWidth: CGFloat = 16

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GeistSpacing.lg) {
                // User info section
                if let user = store.currentUser {
                    userSection(user: user)
                } else if store.isScopedToken {
                    scopedTokenSection
                }

                // Team selection; Vercel infers a scoped token's team
                if !store.isScopedToken {
                    teamSection
                }

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
        #if DEBUG
        // Screenshot tooling (see DemoData).
        .defaultScrollAnchor(DemoData.scrollAnchor)
        #endif
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

    /// Stands in for the account, which Vercel won't show a scoped token:
    /// names the projects the token can see instead.
    private var scopedTokenSection: some View {
        VStack(alignment: .leading, spacing: GeistSpacing.sm) {
            sectionHeader("Account")

            HStack(spacing: GeistSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(GeistColors.foreground(colorScheme))
                        .frame(width: 40, height: 40)

                    Image(systemName: "key.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(GeistColors.background(colorScheme))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Limited access token")
                        .font(GeistFont.medium(GeistFont.bodyLarge))
                        .foregroundColor(GeistColors.foreground(colorScheme))
                    Text(store.projects.isEmpty
                         ? "Limited to a team or project"
                         : store.projects.map(\.name).joined(separator: ", "))
                        .font(GeistFont.regular(GeistFont.footnote))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                        .lineLimit(1)
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

            // The card is the menu: the header names it, the card shows the
            // team, and the menu checks it.
            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 12))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                    .frame(width: Self.iconColumnWidth)
                Text(store.selectedTeam?.displayName ?? "Personal account")
                    .font(GeistFont.regular(GeistFont.body))
                    .foregroundColor(GeistColors.foreground(colorScheme))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            }
            .padding(GeistSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(GeistColors.backgroundSecondary(colorScheme))
            .cornerRadius(GeistRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.md)
                    .stroke(GeistColors.border(colorScheme), lineWidth: 1)
            )
            .accessibilityHidden(true)
            .overlay(
                DropdownMenu(label: "Team", sections: [
                    [DropdownMenu.Item(title: "Personal account", isChecked: store.selectedTeam == nil) {
                        store.selectTeam(nil)
                    }],
                    store.teams.map { team in
                        DropdownMenu.Item(title: team.displayName, isChecked: team.id == store.selectedTeam?.id) {
                            store.selectTeam(team)
                        }
                    },
                ])
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
                    GeistDivider()
                        .padding(.horizontal, GeistSpacing.sm)

                    settingsToggle(
                        icon: nil,
                        title: "Notify on failed deployments",
                        isOn: $settings.notifyOnFailure,
                        iconColor: GeistColors.error
                    )

                    GeistDivider()
                        .padding(.horizontal, GeistSpacing.sm)

                    settingsToggle(
                        icon: nil,
                        title: "Notify on successful deployments",
                        isOn: $settings.notifyOnSuccess,
                        iconColor: GeistColors.success
                    )
                }

                if !notificationManager.isAuthorized {
                    GeistDivider()
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
                                .frame(width: Self.iconColumnWidth)
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
                    // The icon sits on the title's line, not between its two.
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "menubar.rectangle")
                            .font(.system(size: 12))
                            .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                            .frame(width: Self.iconColumnWidth)
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

                GeistDivider()
                    .padding(.horizontal, GeistSpacing.sm)

                linkRow(
                    icon: "star",
                    title: "Star on GitHub",
                    url: "https://github.com/deebov/vercelian"
                )

                GeistDivider()
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
                HStack(spacing: 6) {
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
                HStack(spacing: 6) {
                    Image(systemName: "power")
                        .font(.system(size: 12, weight: .medium))
                    Text("Quit")
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
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
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
                        .frame(width: Self.iconColumnWidth)
                } else if let color = iconColor {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                        .frame(width: Self.iconColumnWidth)
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
                    .frame(width: Self.iconColumnWidth)
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

// MARK: - Dropdown Menu

/// Covers a view and opens a menu right below it, as wide as it. SwiftUI's
/// `Menu` places its menu by its own rules, a few points off the edges of a
/// custom label.
private struct DropdownMenu: NSViewRepresentable {
    struct Item {
        let title: String
        let isChecked: Bool
        let action: () -> Void
    }

    /// What VoiceOver calls the menu's button.
    let label: String
    /// Groups of items, with a separator between groups.
    let sections: [[Item]]

    func makeNSView(context: Context) -> TriggerView {
        TriggerView()
    }

    func updateNSView(_ view: TriggerView, context: Context) {
        view.label = label
        view.sections = sections
    }

    final class TriggerView: NSView {
        var label = ""
        var sections: [[Item]] = []

        override func mouseDown(with event: NSEvent) {
            showMenu()
        }

        private func showMenu() {
            let menu = NSMenu()
            for section in sections where !section.isEmpty {
                if !menu.items.isEmpty {
                    menu.addItem(.separator())
                }
                for item in section {
                    let menuItem = NSMenuItem(title: item.title, action: #selector(choose(_:)), keyEquivalent: "")
                    menuItem.target = self
                    menuItem.state = item.isChecked ? .on : .off
                    menuItem.representedObject = item.action
                    menu.addItem(menuItem)
                }
            }
            menu.minimumWidth = bounds.width
            menu.appearance = effectiveAppearance
            // AppKit puts the first item at the point, below the menu's own
            // top padding, so aim that much lower for the menu's edge to sit
            // just below this view's bottom-left corner.
            let topPadding: CGFloat = 5
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: -(GeistSpacing.xxs + topPadding)), in: self)
        }

        @objc private func choose(_ sender: NSMenuItem) {
            (sender.representedObject as? () -> Void)?()
        }

        // Keyboard and VoiceOver users open the same menu.

        override var acceptsFirstResponder: Bool {
            NSApp.isFullKeyboardAccessEnabled
        }

        override func keyDown(with event: NSEvent) {
            if event.charactersIgnoringModifiers == " " || event.charactersIgnoringModifiers == "\r" {
                showMenu()
            } else {
                super.keyDown(with: event)
            }
        }

        override var focusRingMaskBounds: NSRect {
            bounds
        }

        override func drawFocusRingMask() {
            NSBezierPath(roundedRect: bounds, xRadius: GeistRadius.md, yRadius: GeistRadius.md).fill()
        }

        override func isAccessibilityElement() -> Bool {
            true
        }

        override func accessibilityRole() -> NSAccessibility.Role? {
            .popUpButton
        }

        override func accessibilityLabel() -> String? {
            label
        }

        override func accessibilityValue() -> Any? {
            sections.joined().first(where: \.isChecked)?.title
        }

        override func accessibilityPerformPress() -> Bool {
            showMenu()
            return true
        }
    }
}

#Preview {
    SettingsView(showSettings: .constant(true))
        .frame(width: 380, height: 500)
}
