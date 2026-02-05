# Vercelian

A native macOS menu bar app for monitoring Vercel deployments. Built with SwiftUI.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-green)

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
   git clone https://github.com/yourusername/vercelian.git
   cd vercelian
   ```

2. Build with Swift Package Manager:
   ```bash
   swift build -c release
   ```

3. Copy to Applications:
   ```bash
   cp -r .build/release/Vercelian /Applications/
   ```

### Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15+ or Swift 5.9+ (for building)

## Setup

1. Launch Vercelian from your Applications folder
2. Click the triangle icon (▲) in your menu bar
3. Click **"Sign in with Vercel"** - this opens your browser to create an access token
4. In your browser:
   - Sign in to Vercel (if not already signed in)
   - Give your token a name (e.g., "Vercelian")
   - Select the scope - "Full Account" recommended for all features
   - Click "Create Token"
   - Copy the generated token
5. Paste the token back in Vercelian and click **"Connect"**

### Token Permissions

For full functionality, your token needs these permissions:
- **Read deployments** - View deployment status and history
- **Read projects** - List and filter by projects
- **Read teams** - Switch between personal and team accounts

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

## Development

### Project Structure

```
Vercelian/
├── Sources/
│   ├── App/
│   │   ├── VercelianApp.swift      # App entry point
│   │   └── AppDelegate.swift       # Menu bar setup
│   ├── Views/
│   │   ├── ContentView.swift       # Main container
│   │   ├── LoginView.swift         # Authentication flow
│   │   ├── DeploymentListView.swift
│   │   ├── DeploymentRowView.swift
│   │   ├── DeploymentDetailView.swift
│   │   ├── ProjectSelectorView.swift
│   │   └── SettingsView.swift
│   ├── Models/
│   │   ├── Deployment.swift        # Deployment data model
│   │   └── Project.swift           # Project/Team models
│   ├── Services/
│   │   ├── VercelAPI.swift         # Vercel REST API client
│   │   ├── DeploymentStore.swift   # State management
│   │   └── OAuthManager.swift      # OAuth utilities (for future use)
│   └── Utils/
│       └── KeychainManager.swift   # Secure token storage
└── Package.swift
```

### Building

```bash
# Debug build
swift build

# Release build
swift build -c release

# Run locally
.build/debug/Vercelian
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

### Ideas for Contribution

- [ ] Native notifications for deployment status changes
- [ ] Keyboard shortcuts
- [ ] Multiple account support
- [ ] Deployment logs viewer
- [ ] GitHub Actions integration (like Deplog 2.0)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [Deplog](https://apps.apple.com/app/deplog/id6739449266) - a similar commercial app for Vercel deployments.
