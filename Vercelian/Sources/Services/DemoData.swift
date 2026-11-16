import SwiftUI

/// A fictional account for App Store screenshots. Launch a Debug build with
/// `--demo` and the store shows this instead of real data, without touching
/// the Keychain or the network. Release builds contain none of it.
enum DemoData {
    #if DEBUG
    static let isEnabled = ProcessInfo.processInfo.arguments.contains("--demo")

    /// `--show-popover`: open the popover shortly after launch, so a window
    /// capture needs no click.
    static let showsPopoverAtLaunch = ProcessInfo.processInfo.arguments.contains("--show-popover")

    /// `--appearance dark|light`: force the popover's appearance.
    static var forcedAppearance: NSAppearance.Name? {
        switch argument(after: "--appearance") {
        case "dark": return .darkAqua
        case "light": return .aqua
        default: return nil
        }
    }

    /// `--screen detail|settings`: the screen the popover opens on.
    static var initialScreen: String? {
        argument(after: "--screen")
    }

    /// `--scroll <0…1>`: how far down the list, detail and settings screens open
    /// scrolled, from 0 (the top) to 1 (the bottom).
    static var scrollAnchor: UnitPoint? {
        argument(after: "--scroll").flatMap(Double.init).map { UnitPoint(x: 0.5, y: $0) }
    }

    /// `--render`: draw the popover's content at 4x, write it as a PNG to
    /// standard output, and quit. Sharper than a screen capture, which is
    /// limited to 2x; stdout because the sandbox blocks writing elsewhere.
    static let rendersToStandardOutput = ProcessInfo.processInfo.arguments.contains("--render")

    /// `--notify`: send a notification for the failed deployment shortly
    /// after launch, as the store does when a build fails.
    static let sendsNotification = ProcessInfo.processInfo.arguments.contains("--notify")

    /// `--swipe`: the row whose swipe actions open at launch, the
    /// `feat/gift-cards` preview.
    static var swipedRowId: String? {
        ProcessInfo.processInfo.arguments.contains("--swipe") ? "dpl_demo_9d2b6c0e4" : nil
    }

    private static func argument(after flag: String) -> String? {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: flag), index + 1 < arguments.count else { return nil }
        return arguments[index + 1]
    }

    static let user = User(id: "demo_user", email: "alex@example.com", name: "Alex Rivera", username: "alexrivera")

    static let teams = [
        Team(id: "team_demo_acme", slug: "acme", name: "Acme"),
        Team(id: "team_demo_labs", slug: "acme-labs", name: "Acme Labs"),
    ]

    static let projects = ["storefront", "marketing-site", "docs", "dashboard", "api"].map {
        Project(id: "prj_demo_\($0)", name: $0, framework: "nextjs", latestDeployments: nil, updatedAt: nil)
    }

    /// Fixed at launch so ages stay consistent across refreshes and the
    /// building row's elapsed time keeps counting up.
    private static let anchor = Date()

    /// Newest first, as the API returns them.
    static var deployments: [Deployment] {
        [
            make("marketing-site", .queued, production: false, branch: "copy/pricing-page",
                 message: "Tighten the pricing page copy", hash: "b81e4d2c9", ago: 40),
            make("storefront", .building, production: true, branch: "main",
                 message: "Add express checkout for returning customers", hash: "4f9c2ab17", ago: 83),
            make("docs", .ready, production: true, branch: "main",
                 message: "Document the new webhooks API", hash: "e3a07f5d1", ago: 6 * 60),
            make("storefront", .ready, production: false, branch: "feat/gift-cards",
                 message: "Show gift card balance on the account page", hash: "9d2b6c0e4", ago: 18 * 60),
            make("dashboard", .error, production: false, branch: "fix/chart-tooltips",
                 message: "Fix tooltip overflow on small charts", hash: "17c5e9a3f", ago: 34 * 60),
            make("api", .ready, production: true, branch: "main",
                 message: "Rate limit the search endpoint", hash: "c64f1b8a0", ago: 72 * 60),
            make("storefront", .ready, production: true, branch: "main",
                 message: "Cache product images at the edge", hash: "a5d83e7b2", ago: 2 * 3600),
            make("dashboard", .canceled, production: false, branch: "feat/onboarding",
                 message: "WIP: new onboarding checklist", hash: "6e0a4c9d5", ago: 3 * 3600),
            make("docs", .ready, production: true, branch: "main",
                 message: "Fix broken links in the CLI guide", hash: "f2b97d1c6", ago: 5 * 3600),
            make("marketing-site", .ready, production: true, branch: "main",
                 message: "Launch the customer stories page", hash: "3c8e5a2f7", ago: 26 * 3600),
        ]
    }

    private static func make(
        _ project: String,
        _ state: DeploymentState,
        production: Bool,
        branch: String,
        message: String,
        hash: String,
        ago seconds: TimeInterval
    ) -> Deployment {
        Deployment(
            uid: "dpl_demo_\(hash)",
            name: project,
            url: "\(project)-\(hash)-acme.vercel.app",
            created: Int(anchor.addingTimeInterval(-seconds).timeIntervalSince1970 * 1000),
            state: state,
            target: production ? "production" : nil,
            meta: DeploymentMeta(
                githubCommitSha: hash + "0d4e1f7a3b6c9e2d5f8a1b4c7d0e",
                githubCommitMessage: message,
                githubCommitRef: branch,
                githubRepo: project,
                githubOrg: "acme"
            ),
            creator: DeploymentCreator(uid: user.id, username: user.username, email: user.email),
            inspectorUrl: "https://vercel.com/acme/\(project)/\(hash)",
            // Every ready production deployment had its aliases assigned at
            // some point; the store marks only the newest per project as live.
            aliasAssigned: production && state == .ready
        )
    }
    #else
    static let isEnabled = false
    #endif
}
