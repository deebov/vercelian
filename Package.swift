// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Vercelian",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "Vercelian",
            path: "Vercelian/Sources"
        )
    ]
)
