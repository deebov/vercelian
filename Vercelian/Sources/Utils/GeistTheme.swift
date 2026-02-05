import SwiftUI

// MARK: - Geist Design System Colors
// Based on Vercel's Geist Design System: https://vercel.com/geist/colors

struct GeistColors {
    // MARK: - Gray Scale (Light Theme)
    static let gray0 = Color(hex: "FFFFFF")
    static let gray1 = Color(hex: "FAFAFA")
    static let gray2 = Color(hex: "EAEAEA")
    static let gray3 = Color(hex: "999999")
    static let gray4 = Color(hex: "888888")
    static let gray5 = Color(hex: "666666")
    static let gray6 = Color(hex: "444444")
    static let gray7 = Color(hex: "333333")
    static let gray8 = Color(hex: "111111")

    // MARK: - Gray Scale (Dark Theme)
    static let grayDark0 = Color(hex: "000000")
    static let grayDark1 = Color(hex: "111111")
    static let grayDark2 = Color(hex: "1A1A1A")
    static let grayDark3 = Color(hex: "333333")
    static let grayDark4 = Color(hex: "444444")
    static let grayDark5 = Color(hex: "666666")
    static let grayDark6 = Color(hex: "888888")
    static let grayDark7 = Color(hex: "999999")
    static let grayDark8 = Color(hex: "FAFAFA")

    // MARK: - Brand Colors
    static let vercelBlue = Color(hex: "0070F3")
    static let vercelBlueDark = Color(hex: "0761D1")
    static let vercelBlueLight = Color(hex: "3291FF")
    static let vercelBlueLighter = Color(hex: "D3E5FF")

    // MARK: - Status Colors - Ready (Green - Vercel green)
    static let successLighter = Color(hex: "D3F9D8")
    static let successLight = Color(hex: "52C41A")
    static let success = Color(hex: "17B169")
    static let successDark = Color(hex: "0A7E00")

    // MARK: - Status Colors - Error (Red)
    static let errorLighter = Color(hex: "F7D4D6")
    static let errorLight = Color(hex: "FF1A1A")
    static let error = Color(hex: "EE0000")
    static let errorDark = Color(hex: "C50000")

    // MARK: - Status Colors - Building (Yellow/Amber - Vercel uses this for BUILDING state)
    static let warningLighter = Color(hex: "FFF5CC")
    static let warningLight = Color(hex: "FFD633")
    static let warning = Color(hex: "F5A623")
    static let warningDark = Color(hex: "AB570A")

    // MARK: - Status Colors - Queued (Gray)
    static let queued = Color(hex: "888888")

    // MARK: - Status Colors - Cyan
    static let cyanLighter = Color(hex: "AAFFEC")
    static let cyanLight = Color(hex: "79FFE1")
    static let cyan = Color(hex: "50E3C2")
    static let cyanDark = Color(hex: "29BC9B")

    // MARK: - Status Colors - Violet/Purple
    static let violetLighter = Color(hex: "E3D7FC")
    static let violetLight = Color(hex: "8A63D2")
    static let violet = Color(hex: "7928CA")
    static let violetDark = Color(hex: "4C2889")

    // MARK: - Highlight Colors
    static let pink = Color(hex: "FF0080")
    static let purple = Color(hex: "F81CE5")
    static let magenta = Color(hex: "EB367F")

    // MARK: - Semantic Colors (adapts to color scheme)
    static func background(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark1 : gray0
    }

    static func backgroundSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark2 : gray1
    }

    static func backgroundTertiary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark3 : gray2
    }

    static func foreground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark8 : gray8
    }

    static func foregroundSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark6 : gray5
    }

    static func foregroundTertiary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark5 : gray4
    }

    static func border(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark2 : gray2
    }

    static func borderSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? grayDark4 : gray3
    }
}

// MARK: - Geist Typography

struct GeistFont {
    // Sizes based on Geist type scale
    static let caption2: CGFloat = 10
    static let caption: CGFloat = 11
    static let footnote: CGFloat = 12
    static let body: CGFloat = 13
    static let bodyLarge: CGFloat = 14
    static let title3: CGFloat = 16
    static let title2: CGFloat = 20
    static let title: CGFloat = 24
    static let largeTitle: CGFloat = 32

    // Font weights
    static func regular(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func medium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func semibold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func bold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
}

// MARK: - Geist Spacing

struct GeistSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Geist Radius

struct GeistRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 6
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let full: CGFloat = 9999
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Geist Button Style

struct GeistButtonStyle: ButtonStyle {
    enum Variant {
        case primary
        case secondary
        case ghost
        case error
    }

    let variant: Variant
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(GeistFont.medium(GeistFont.body))
            .padding(.horizontal, GeistSpacing.md)
            .padding(.vertical, GeistSpacing.xs)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .cornerRadius(GeistRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: GeistRadius.sm)
                    .stroke(borderColor, lineWidth: 1)
            )
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return isPressed ? GeistColors.grayDark1 : GeistColors.gray8
        case .secondary:
            return isPressed ? GeistColors.backgroundTertiary(colorScheme) : GeistColors.backgroundSecondary(colorScheme)
        case .ghost:
            return isPressed ? GeistColors.backgroundTertiary(colorScheme) : .clear
        case .error:
            return isPressed ? GeistColors.errorDark : GeistColors.error
        }
    }

    private func foregroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return .white
        case .secondary, .ghost:
            return GeistColors.foreground(colorScheme)
        case .error:
            return .white
        }
    }

    private var borderColor: Color {
        switch variant {
        case .primary:
            return .clear
        case .secondary:
            return GeistColors.border(colorScheme)
        case .ghost:
            return .clear
        case .error:
            return .clear
        }
    }
}

// MARK: - Sharp Triangle Shape

struct SharpTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

// MARK: - Vercel Logo View

struct VercelLogo: View {
    var size: CGFloat = 20
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        SharpTriangle()
            .fill(GeistColors.foreground(colorScheme))
            .frame(width: size, height: size * 0.875)
    }
}

// MARK: - Status Badge View

struct GeistStatusBadge: View {
    let state: DeploymentState
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .modifier(state.isInProgress ? PulseAnimation() : PulseAnimation(enabled: false))

            Text(state.displayName)
                .font(GeistFont.medium(GeistFont.caption))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(statusColor.opacity(0.1))
        .cornerRadius(GeistRadius.full)
    }

    private var statusColor: Color {
        switch state {
        case .ready:
            return GeistColors.success // Green
        case .error:
            return GeistColors.error // Red
        case .building, .initializing:
            return GeistColors.warning // Yellow/Amber
        case .queued:
            return GeistColors.queued // Gray
        case .canceled:
            return GeistColors.queued // Gray
        }
    }
}

// MARK: - Pulse Animation

struct PulseAnimation: ViewModifier {
    var enabled: Bool = true
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(enabled && isPulsing ? 1.3 : 1.0)
            .opacity(enabled && isPulsing ? 0.6 : 1.0)
            .animation(
                enabled ? Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                value: isPulsing
            )
            .onAppear {
                if enabled {
                    isPulsing = true
                }
            }
    }
}

// MARK: - Deployment State Extension

extension DeploymentState {
    var isInProgress: Bool {
        switch self {
        case .building, .initializing, .queued:
            return true
        default:
            return false
        }
    }
}
