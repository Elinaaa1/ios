import SwiftUI

// MARK: - USTAWIENIA PRZYPOMNIENIA W FORMULARZU WYDARZENIA
struct ReminderSettingsView: View {
    @Binding var selectedReminder: ReminderOption

    var body: some View {
        Section {
            Picker("Remind me", selection: $selectedReminder) {
                ForEach(ReminderOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
        } header: {
            Text("Reminder")
        } footer: {
            Text("Local notification on this iPhone. Notifications need system permission.")
        }
    }
}
