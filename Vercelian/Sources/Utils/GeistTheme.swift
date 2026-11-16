import SwiftUI
import AppKit

// MARK: - Geist Design System Colors
// Vercel's Geist colors: https://vercel.com/geist/colors. Hex values are the
// sRGB ones Vercel ships alongside its P3 colors, light | dark.

struct GeistColors {
    // MARK: - Grays
    // Geist's steps: Background 1 for surfaces, Gray 100–200 for component
    // fills (default or hover, then active), Gray 400–500 for borders, and
    // Gray 900–1000 for text and icons.

    static func background(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "0A0A0A") : Color(hex: "FFFFFF")
    }

    static func backgroundSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "1A1A1A") : Color(hex: "F2F2F2")
    }

    static func backgroundTertiary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "1F1F1F") : Color(hex: "EBEBEB")
    }

    static func foreground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "EDEDED") : Color(hex: "171717")
    }

    static func foregroundSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "A1A1A1") : Color(hex: "4D4D4D")
    }

    /// Gray 700. Geist names two text colors; this quieter one is for
    /// times, hints and chevrons.
    static func foregroundTertiary(_ colorScheme: ColorScheme) -> Color {
        Color(hex: "8F8F8F")
    }

    static func border(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "2E2E2E") : Color(hex: "EBEBEB")
    }

    static func borderSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "454545") : Color(hex: "C9C9C9")
    }

    /// Rules between rows and sections, between the Gray 400 and Gray 500
    /// borders in weight.
    static func divider(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "383838") : Color(hex: "E0E0E0")
    }

    // MARK: - Accents

    /// Blue 700, for fills.
    static let vercelBlue = Color(light: "0070F7", dark: "0071F6")
    /// Blue 900, for links and other blue text.
    static let link = Color(light: "0064E2", dark: "50A8FF")
    /// Green 700.
    static let success = Color(light: "28A948", dark: "00AB3E")
    /// Red 900, for text and icons.
    static let error = Color(light: "D60020", dark: "FF5E63")
    /// Amber 900, for text and icons.
    static let warning = Color(light: "A64F00", dark: "FF9900")
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

extension Color {
    /// Resolves to `light` or `dark` with the view's appearance.
    init(light: String, dark: String) {
        let light = NSColor(Color(hex: light))
        let dark = NSColor(Color(hex: dark))
        self.init(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
        })
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
            return GeistColors.foreground(colorScheme).opacity(isPressed ? 0.85 : 1)
        case .secondary:
            return isPressed ? GeistColors.backgroundTertiary(colorScheme) : GeistColors.backgroundSecondary(colorScheme)
        case .ghost:
            return isPressed ? GeistColors.backgroundTertiary(colorScheme) : .clear
        case .error:
            return GeistColors.error.opacity(isPressed ? 0.85 : 1)
        }
    }

    private func foregroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary:
            return GeistColors.background(colorScheme)
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

// MARK: - Divider

/// A one-point rule in the divider color. SwiftUI's `Divider` draws the
/// system separator on top of any color it's given, which darkens it.
struct GeistDivider: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Rectangle()
            .fill(GeistColors.divider(colorScheme))
            .frame(height: 1)
    }
}

// MARK: - Status Dot

/// Geist's Status Dot (https://vercel.com/geist/status-dot): ten points
/// unless set smaller, colored by the deployment's state, pulsing while it's
/// queued or building.
struct StatusDot: View {
    let state: DeploymentState
    var size: CGFloat = 10

    var body: some View {
        ZStack {
            if state.isInProgress {
                Circle()
                    .fill(color)
                    .modifier(ExpandingPulse())
            }
            Circle()
                .fill(color)
        }
        .frame(width: size, height: size)
    }

    /// Ready takes the green the rest of the app uses for success; the other
    /// states keep Vercel's original status colors, unlike the scales above.
    private var color: Color {
        switch state {
        case .ready: return GeistColors.success
        case .building, .initializing: return Color(hex: "F5A623")
        case .error, .blocked: return Color(light: "EE0000", dark: "FF0000")
        case .queued, .canceled: return Color(light: "EAEAEA", dark: "333333")
        }
    }
}

/// A status dot with the state's name beside it, as Geist labels a dot that
/// stands on its own. The name stays in the text color: the dot carries the
/// state's color. A step below body text, so it reads as a badge.
struct StatusLabel: View {
    let state: DeploymentState
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 6) {
            StatusDot(state: state, size: 8)
            Text(state.displayName)
                .font(GeistFont.regular(GeistFont.footnote))
                .foregroundColor(GeistColors.foreground(colorScheme))
        }
    }
}

// MARK: - Badge

/// Geist's Badge (https://vercel.com/geist/badge), in its small size or a
/// step below it.
struct GeistBadge: View {
    enum Variant {
        case greenSubtle
        case blueSubtle

        /// Geist mixes these from Green 200 and Blue 200; these are its
        /// results in sRGB.
        var fill: Color {
            switch self {
            case .greenSubtle: return Color(light: "D7F5D9", dark: "003011")
            case .blueSubtle: return Color(light: "DFEDFC", dark: "002552")
            }
        }

        /// Green 900 and Blue 900.
        var text: Color {
            switch self {
            case .greenSubtle: return Color(light: "107D32", dark: "00CA52")
            case .blueSubtle: return GeistColors.link
            }
        }
    }

    enum Size {
        /// A step below Geist's smallest, to sit beside body text.
        case xs
        /// Geist's small size.
        case sm

        var fontSize: CGFloat { self == .xs ? GeistFont.caption2 : GeistFont.caption }
        var height: CGFloat { self == .xs ? 18 : 20 }
        var padding: CGFloat { self == .xs ? 7 : 8 }
    }

    let title: String
    let variant: Variant
    let size: Size

    init(_ title: String, _ variant: Variant, size: Size = .sm) {
        self.title = title
        self.variant = variant
        self.size = size
    }

    var body: some View {
        Text(title)
            .font(GeistFont.medium(size.fontSize))
            .foregroundColor(variant.text)
            .lineLimit(1)
            .padding(.horizontal, size.padding)
            .frame(height: size.height)
            .background(variant.fill, in: Capsule())
    }
}

// MARK: - Pulse Animation

struct ExpandingPulse: ViewModifier {
    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 2.5 : 1.0)
            .opacity(animate ? 0.0 : 0.6)
            .animation(
                .easeOut(duration: 1.2).repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear {
                animate = true
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
