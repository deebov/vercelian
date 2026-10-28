# Vercelian

A native macOS menu bar app for monitoring Vercel deployments. Built with SwiftUI.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Download

- **GitHub Releases**: Download the latest `.zip` from [Releases](https://github.com/deebov/vercelian/releases)
- **App Store**: Coming soon

> **Note**: GitHub builds are not notarized, so macOS blocks them on first launch. To open one:
> 1. Double-click **Vercelian.app** and dismiss the warning
> 2. Open **System Settings → Privacy & Security**
> 3. Scroll to the message saying Vercelian was blocked and click **Open Anyway**
>
> You only need to do this once. (On macOS 15 Sequoia and later, Control-click → Open no longer bypasses this.)

## Features

- **Menu Bar Access**: Quick access to your deployments from the macOS menu bar
- **Real-Time Monitoring**: Auto-refreshes every 10 seconds to show latest deployment status
- **Deployment Status**: Color-coded indicators (green = ready, orange = building, red = error)
- **Build Time Tracking**: Shows elapsed time for in-progress builds
- **Team Support**: Switch between personal account and team deployments
- **Project Filtering**: Filter deployments by specific project
- **Deployment Details**: View commit info, branch, and repository details
- **Quick Actions**: Cancel builds, redeploy, or open in browser
- **Secure Storage**: Access token stored securely in macOS Keychain
- **Dark Mode**: Automatically matches your macOS appearance

## Installation

### Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/deebov/vercelian.git
   cd vercelian
   ```

2. Open in Xcode and build:
   ```bash
   open Vercelian.xcodeproj
   ```

### Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15+ (for building from source)

## Setup

1. Launch Vercelian from your Applications folder
2. Click the triangle icon in your menu bar
3. Click **Continue with Vercel**. Your browser opens [vercel.com/account/tokens](https://vercel.com/account/tokens)
4. Create a token and copy it
5. Paste it into Vercelian and click **Connect**

If the token later expires or is revoked, Vercelian signs out and asks for a new one.

### The menu bar icon is missing

On a MacBook with a notch, status icons that don't fit to the right of the notch are hidden, starting with the most recently launched app. That is usually Vercelian, since it's often started after everything else. To get it back:

1. Quit another menu bar app (or several) until the triangle reappears
2. Hold **⌘** and drag the triangle further right, past icons you use less

macOS remembers the new position on future launches.

## Usage

- **Click the menu bar icon** to open the deployment list
- **Filter by team** using the team dropdown (if you have team access)
- **Filter by project** using the project dropdown
- **Click a deployment** to see details and actions
- **Click the refresh icon** to manually refresh
- **Click Settings** (gear icon) to manage your account or sign out

### Deployment Actions

From the deployment detail view, you can:
- **Open in Browser** - View the deployed site
- **View on Vercel** - Open the deployment in Vercel dashboard
- **Cancel** - Stop an in-progress build
- **Redeploy** - Trigger a new deployment

## Security

- Your Vercel access token is stored securely in **macOS Keychain**
- The token never leaves your machine except to communicate with Vercel's official API
- All network requests use HTTPS
- No analytics or tracking - completely private

See the [Privacy Policy](PRIVACY.md) for exactly what the app stores and sends.

## Development

### Project Structure

```
Vercelian/
├── Sources/
│   ├── App/
│   │   ├── VercelianApp.swift
│   │   └── AppDelegate.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── LoginView.swift
│   │   ├── DeploymentListView.swift
│   │   ├── DeploymentRowView.swift
│   │   ├── DeploymentDetailView.swift
│   │   ├── ProjectSelectorView.swift
│   │   └── SettingsView.swift
│   ├── Models/
│   │   ├── Deployment.swift
│   │   └── Project.swift
│   ├── Services/
│   │   ├── VercelAPI.swift
│   │   ├── DeploymentStore.swift
│   │   ├── NotificationManager.swift
│   │   └── SettingsManager.swift
│   └── Utils/
│       ├── GeistTheme.swift
│       └── KeychainManager.swift
├── Assets.xcassets
├── Info.plist
└── Vercelian.entitlements
```

### Architecture

- **SwiftUI** for the UI layer
- **NSStatusItem** for menu bar integration
- **NSPopover** for the dropdown panel
- **Async/await** for API calls
- **Combine** for reactive state management
- **Security.framework** for Keychain access

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Commit and push to your branch
5. Open a Pull Request

### Ideas for Contribution

- [ ] Keyboard shortcuts
- [ ] Multiple account support
- [ ] Deployment logs viewer
- [ ] Sparkle auto-update integration

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [Deplog](https://apps.apple.com/app/deplog/id6739449266) - a similar commercial app for Vercel deployments.
