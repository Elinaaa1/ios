import SwiftUI

// MARK: - HOME: WIDOK; DANE POCHODZA Z EVENTSTORE
struct HomeView: View {
    @EnvironmentObject private var store: EventStore
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("GOOD VIBES ONLY", systemImage: "sparkles")
                            .font(.caption.bold())
                        Text("Make plans. Make memories.")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text("MeetUp makes planning with friends easy.")
                            .font(.subheadline)
                        HStack(spacing: 10) {
                            Label("\(store.meetings.count) events", systemImage: "calendar")
                            Label("\(store.friends.count) friends", systemImage: "person.2")
                        }.font(.caption.bold()).padding(.top, 8)
                    }
                    .foregroundStyle(AppTheme.textPrimary)
                    .padding(22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 26))

                    Button { showingCreate = true } label: {
                        Label("Create a new event", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity).padding(16)
                            .background(AppTheme.mainGradient, in: RoundedRectangle(cornerRadius: 18))
                            .foregroundStyle(.white)
                    }
                    Text("Coming up").font(.title2.bold()).foregroundStyle(AppTheme.textPrimary)
                    if store.upcomingMeetings.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "party.popper.fill").font(.largeTitle).foregroundStyle(AppTheme.pink)
                            Text("No plans yet — time to change that!")
                                .font(.headline).foregroundStyle(AppTheme.textPrimary)
                        }.frame(maxWidth: .infinity).slayCard()
                    } else {
                        ForEach(store.upcomingMeetings.prefix(5)) { meeting in
                            NavigationLink(value: meeting.id) { EventCard(meeting: meeting) }.buttonStyle(.plain)
                        }
                    }
                }.padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("MeetUp")
            .tint(AppTheme.pink)
            .navigationDestination(for: UUID.self) { id in EventDetailView(meetingID: id) }
            .sheet(isPresented: $showingCreate) { EventEditorView() }
        }
    }
}
