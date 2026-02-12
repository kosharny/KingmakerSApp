import SwiftUI

struct ThemeColorsKS {
    let background: LinearGradient
    let cardBackground: Color
    let primaryAccent: Color
    let secondaryAccent: Color
    let textPrimary: Color
    let textSecondary: Color
    let glowColor: Color
    
    static func colors(for theme: ThemeKS) -> ThemeColorsKS {
        switch theme {
        case .royalDefault:
            return ThemeColorsKS(
                background: LinearGradient(
                    colors: [
                        Color(hex: "1C1B3A"),
                        Color(hex: "0E0F1C"),
                        Color(hex: "1C1B3A")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                cardBackground: Color(hex: "1C1B3A").opacity(0.6),
                primaryAccent: Color(hex: "D4AF37"),
                secondaryAccent: Color(hex: "9B7EBD"),
                textPrimary: Color(hex: "F5F5F7"),
                textSecondary: Color(hex: "B8B8BA"),
                glowColor: Color(hex: "9B7EBD")
            )
        case .obsidianThrone:
            return ThemeColorsKS(
                background: LinearGradient(
                    colors: [
                        Color(hex: "0A0A0A"),
                        Color(hex: "1A1A2E"),
                        Color(hex: "0A0A0A")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                cardBackground: Color(hex: "1A1A2E").opacity(0.7),
                primaryAccent: Color(hex: "C0C0C0"),
                secondaryAccent: Color(hex: "6A5ACD"),
                textPrimary: Color(hex: "FFFFFF"),
                textSecondary: Color(hex: "A0A0A0"),
                glowColor: Color(hex: "6A5ACD")
            )
        case .crimsonEmpire:
            return ThemeColorsKS(
                background: LinearGradient(
                    colors: [
                        Color(hex: "2C0A0E"),
                        Color(hex: "1A0A0E"),
                        Color(hex: "2C0A0E")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                cardBackground: Color(hex: "3D1319").opacity(0.7),
                primaryAccent: Color(hex: "FFD700"),
                secondaryAccent: Color(hex: "DC143C"),
                textPrimary: Color(hex: "F5F5F7"),
                textSecondary: Color(hex: "C8A2A8"),
                glowColor: Color(hex: "DC143C")
            )
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
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
