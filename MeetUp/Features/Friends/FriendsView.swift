import SwiftUI

// MARK: - ZNAJOMI; OPERACJE ZAPISU W EVENTSTORE
struct FriendsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var name = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Better together 💖").font(.largeTitle.bold())
                        Text("Add people to your next plan.").font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(20)
                    .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 24))
                    HStack {
                        TextField("Friend's name", text: $name).textFieldStyle(.roundedBorder)
                        Button("Add") {
                            store.addFriend(name)
                            name = ""
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .buttonStyle(.borderedProminent)
                    }.slayCard()
                    ForEach(store.friends, id: \.self) { friend in
                        HStack(spacing: 14) {
                            Image(systemName: "person.fill")
                                .frame(width: 42, height: 42).foregroundStyle(.white)
                                .background(AppTheme.mainGradient, in: Circle())
                            Text(friend).font(.headline).foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                            Button(role: .destructive) { store.removeFriend(friend) } label: {
                                Image(systemName: "trash").foregroundStyle(AppTheme.pink)
                            }.accessibilityLabel("Remove \(friend)")
                        }.slayCard()
                    }
                    if store.friends.isEmpty {
                        Text("No friends yet. Add someone above!")
                            .foregroundStyle(AppTheme.textSecondary).slayCard()
                    }
                }.padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Friends").tint(AppTheme.pink)
        }
    }
}
