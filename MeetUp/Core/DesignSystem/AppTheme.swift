// MARK: - KOLORY I STYL
// Wspolne kolory i gradient uzywane w wielu ekranach.

import SwiftUI

enum AppTheme {
    static let pink = Color(red: 0.98, green: 0.33, blue: 0.67)
    static let turquoise = Color(red: 0.22, green: 0.82, blue: 0.78)
    static let lavender = Color(red: 0.73, green: 0.63, blue: 0.98)
    static let background = Color(red: 0.99, green: 0.96, blue: 0.99)
    static let textPrimary = Color(red: 0.18, green: 0.16, blue: 0.25)
    static let mainGradient = LinearGradient(
        colors: [pink, turquoise],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
