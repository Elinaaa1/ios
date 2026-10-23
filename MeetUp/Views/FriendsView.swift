import SwiftUI

struct FriendsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var name = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add a friend") {
                    HStack {
                        TextField("Friend's name", text: $name)
                        Button("Add") {
                            store.addFriend(name)
                            name = ""
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                Section("Friends") {
                    if store.friends.isEmpty {
                        Text("No friends added yet.").foregroundStyle(.secondary)
                    }
                    ForEach(store.friends, id: \.self) { friend in
                        Label(friend, systemImage: "person.circle.fill")
                    }
                    .onDelete { offsets in
                        let names = store.friends
                        for index in offsets { store.removeFriend(names[index]) }
                    }
                }
            }
            .navigationTitle("Friends")
        }
    }
}
