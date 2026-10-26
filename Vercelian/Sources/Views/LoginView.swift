import SwiftUI
import AppKit

struct LoginView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme

    @State private var token = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var browserOpened = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Logo and title
            VStack(spacing: GeistSpacing.md) {
                VercelLogo(size: 48)

                Text("Vercelian")
                    .font(GeistFont.bold(GeistFont.title))
                    .foregroundColor(GeistColors.foreground(colorScheme))

                Text("Monitor your Vercel deployments\nfrom the menu bar")
                    .font(GeistFont.regular(GeistFont.body))
                    .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            Spacer()
                .frame(height: GeistSpacing.xxl)

            if browserOpened {
                tokenEntryView
            } else {
                initialView
            }

            Spacer()

            // Footer
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 10))
                Text("Stored securely in macOS Keychain")
                    .font(GeistFont.regular(GeistFont.caption2))
            }
            .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
            .padding(.bottom, GeistSpacing.md)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GeistColors.background(colorScheme))
    }

    // MARK: - Initial View

    private var initialView: some View {
        VStack(spacing: GeistSpacing.md) {
            if let reason = store.signedOutReason {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(reason)
                        .font(GeistFont.regular(GeistFont.caption))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(GeistColors.error)
                .padding(.horizontal, GeistSpacing.xxl)
            }

            Button(action: openVercelTokenPage) {
                HStack(spacing: 10) {
                    SharpTriangle()
                        .frame(width: 14, height: 12.25)
                    Text("Continue with Vercel")
                        .font(GeistFont.medium(GeistFont.body))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, GeistSpacing.sm)
                .background(GeistColors.foreground(colorScheme))
                .foregroundColor(GeistColors.background(colorScheme))
                .cornerRadius(GeistRadius.sm)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, GeistSpacing.xxl)

            Text("Opens Vercel to create an access token")
                .font(GeistFont.regular(GeistFont.caption))
                .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
        }
    }

    // MARK: - Token Entry View

    private var tokenEntryView: some View {
        VStack(spacing: GeistSpacing.lg) {
            VStack(spacing: GeistSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(GeistColors.backgroundSecondary(colorScheme))
                        .frame(width: 48, height: 48)

                    Image(systemName: "key.fill")
                        .font(.system(size: 20))
                        .foregroundColor(GeistColors.foregroundSecondary(colorScheme))
                }

                Text("Paste your access token")
                    .font(GeistFont.semibold(GeistFont.bodyLarge))
                    .foregroundColor(GeistColors.foreground(colorScheme))

                Text("Create a token in the browser, then paste it here")
                    .font(GeistFont.regular(GeistFont.caption))
                    .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: GeistSpacing.sm) {
                SecureField("", text: $token)
                    .textFieldStyle(.plain)
                    .font(GeistFont.mono(GeistFont.body))
                    .padding(GeistSpacing.sm)
                    .background(GeistColors.backgroundSecondary(colorScheme))
                    .cornerRadius(GeistRadius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: GeistRadius.sm)
                            .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                    )
                    .disabled(isLoading)
                    .placeholder(when: token.isEmpty) {
                        Text("Paste token here")
                            .font(GeistFont.mono(GeistFont.body))
                            .foregroundColor(GeistColors.foregroundTertiary(colorScheme))
                            .padding(.leading, GeistSpacing.sm)
                    }

                if let error = errorMessage {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12))
                        Text(error)
                            .font(GeistFont.regular(GeistFont.caption))
                    }
                    .foregroundColor(GeistColors.error)
                }
            }
            .padding(.horizontal, GeistSpacing.xxl)

            HStack(spacing: GeistSpacing.sm) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        browserOpened = false
                        token = ""
                        errorMessage = nil
                    }
                }) {
                    Text("Cancel")
                        .font(GeistFont.medium(GeistFont.body))
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

                Button(action: connect) {
                    HStack(spacing: 8) {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.6)
                                .frame(width: 14, height: 14)
                        }
                        Text(isLoading ? "Connecting..." : "Connect")
                            .font(GeistFont.medium(GeistFont.body))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, GeistSpacing.xs)
                    .background(token.isEmpty || isLoading ? GeistColors.foregroundTertiary(colorScheme) : GeistColors.foreground(colorScheme))
                    .foregroundColor(GeistColors.background(colorScheme))
                    .cornerRadius(GeistRadius.sm)
                }
                .buttonStyle(.plain)
                .disabled(token.isEmpty || isLoading)
            }
            .padding(.horizontal, GeistSpacing.xxl)

            Button(action: {
                NSWorkspace.shared.open(URL(string: "https://vercel.com/account/tokens")!)
            }) {
                Text("Open Vercel token page")
                    .font(GeistFont.regular(GeistFont.caption))
                    .foregroundColor(GeistColors.vercelBlue)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Actions

    private func openVercelTokenPage() {
        NSWorkspace.shared.open(URL(string: "https://vercel.com/account/tokens")!)
        withAnimation(.easeInOut(duration: 0.2)) {
            browserOpened = true
        }
    }

    private func connect() {
        guard !token.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task {
            let success = await store.login(token: token.trimmingCharacters(in: .whitespacesAndNewlines))
            isLoading = false

            if !success {
                errorMessage = store.error ?? "Invalid token. Please try again."
            }
        }
    }
}

// MARK: - Placeholder Extension

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    LoginView()
        .frame(width: 380, height: 500)
}
