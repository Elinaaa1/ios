import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: EventStore

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.indigo)
                        VStack(alignment: .leading) {
                            Text("My Profile").font(.headline)
                            Text("Local demo account").font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
                Section("Overview") {
                    LabeledContent("Events", value: "\(store.meetings.count)")
                    LabeledContent("Friends", value: "\(store.friends.count)")
                }
                Section("About") {
                    Text("MeetUp — plan meetings with friends in one place.")
                    Text("This starter version stores data on this device only.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
