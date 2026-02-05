# Vercelian

A native macOS menu bar app for monitoring Vercel deployments. Built with SwiftUI.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Download

- **GitHub Releases**: Download the latest `.app` from [Releases](https://github.com/deebov/vercelian/releases)
- **App Store**: Coming soon

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

2. Copy the example secrets config and fill in your OAuth credentials:
   ```bash
   cp Vercelian/Configuration/Secrets.xcconfig.example Vercelian/Configuration/Secrets.xcconfig
   ```
   Edit `Secrets.xcconfig` with your Vercel OAuth app credentials. You can register an OAuth app at [vercel.com/account/oauth-apps](https://vercel.com/account/oauth-apps).

3. Open in Xcode and build:
   ```bash
   open Vercelian.xcodeproj
   ```

### Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15+ (for building from source)

## Setup

1. Launch Vercelian from your Applications folder
2. Click the triangle icon in your menu bar
3. Click **"Sign in with Vercel"** to authenticate via OAuth
4. Authorize the app in your browser
5. You'll be redirected back to Vercelian automatically

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
- OAuth credentials are loaded from a local config file excluded from git
- The token never leaves your machine except to communicate with Vercel's official API
- All network requests use HTTPS
- No analytics or tracking - completely private

## Development

### Project Structure

```
Vercelian/
├── Configuration/
│   ├── Secrets.xcconfig          # OAuth credentials (git-ignored)
│   └── Secrets.xcconfig.example  # Template for credentials
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
│   │   └── OAuthManager.swift
│   └── Utils/
│       └── KeychainManager.swift
├── Assets.xcassets
├── Info.plist
└── Vercelian.entitlements
```

> **Note**: The app icon (`AppIcon.appiconset`) does not yet contain images. You'll need to add icon files to `Vercelian/Assets.xcassets/AppIcon.appiconset/` before submitting to the App Store.

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
3. Copy `Secrets.xcconfig.example` to `Secrets.xcconfig` and add your credentials
4. Make your changes
5. Commit and push to your branch
6. Open a Pull Request

### Ideas for Contribution

- [ ] Keyboard shortcuts
- [ ] Multiple account support
- [ ] Deployment logs viewer
- [ ] Sparkle auto-update integration

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [Deplog](https://apps.apple.com/app/deplog/id6739449266) - a similar commercial app for Vercel deployments.
