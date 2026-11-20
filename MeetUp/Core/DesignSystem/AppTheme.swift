import SwiftUI

// MARK: - DESIGN SYSTEM
// Wszystkie kolory i style w jednym miejscu. Zmiana palety zmienia cala aplikacje.
enum AppTheme {
    static let pink = Color(red: 0.95, green: 0.20, blue: 0.55)
    static let turquoise = Color(red: 0.05, green: 0.70, blue: 0.70)
    static let lavender = Color(red: 0.65, green: 0.47, blue: 0.92)
    static let background = Color(red: 1.00, green: 0.93, blue: 0.96)
    static let textPrimary = Color(red: 0.20, green: 0.13, blue: 0.25)
    static let textSecondary = Color(red: 0.43, green: 0.35, blue: 0.47)
    static let card = Color.white
    static let mainGradient = LinearGradient(colors: [pink, lavender, turquoise], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let softGradient = LinearGradient(colors: [Color(red: 1, green: 0.79, blue: 0.87), Color(red: 0.77, green: 0.97, blue: 0.96)], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - WSPOLNY WYGLAD KARTY
struct SlayCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppTheme.pink.opacity(0.13), lineWidth: 1))
            .shadow(color: AppTheme.pink.opacity(0.10), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func slayCard() -> some View { modifier(SlayCard()) }
}
