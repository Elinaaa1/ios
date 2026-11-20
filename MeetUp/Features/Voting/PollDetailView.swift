import SwiftUI

// MARK: - WIDOK GLOSOWANIA
// Obliczenia procentow i zmiana glosu zostaly przeniesione do VotingService.
struct PollDetailView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    let meetingID: UUID
    let pollID: UUID
    @State private var selectedVoter = "Me"

    private var meeting: Meeting? { store.meetings.first { $0.id == meetingID } }
    private var poll: MeetingPoll? { meeting?.polls.first { $0.id == pollID } }
    private var voters: [String] { ["Me"] + (meeting?.participantNames.filter { $0 != "Me" } ?? []) }

    var body: some View {
        Group {
            if let poll {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(poll.kind.rawValue.uppercased()).font(.caption.bold())
                            Text(poll.question).font(.largeTitle.bold())
                            Text("\(poll.votes.count) votes • One choice per person")
                                .font(.subheadline)
                        }
                        .foregroundStyle(AppTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(22)
                        .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 24))

                        HStack {
                            Text("Voting as").font(.headline)
                            Spacer()
                            Picker("Person", selection: $selectedVoter) {
                                ForEach(voters, id: \.self) { name in Text(name).tag(name) }
                            }.pickerStyle(.menu)
                        }.slayCard()
                        ForEach(poll.options) { option in optionCard(option, in: poll) }
                        Label(poll.resultText, systemImage: "chart.bar.fill")
                            .font(.headline).foregroundStyle(AppTheme.textPrimary).slayCard()
                        Text("Demo mode: participants vote on this device.")
                            .font(.caption).foregroundStyle(AppTheme.textSecondary)
                        Button("Delete poll", role: .destructive) {
                            guard let meeting else { return }
                            store.update(VotingService.deletingPoll(pollID, from: meeting))
                            dismiss()
                        }.frame(maxWidth: .infinity).padding(.top)
                    }.padding()
                }
                .background(AppTheme.background.ignoresSafeArea())
                .navigationTitle("Poll results")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Poll unavailable", systemImage: "chart.bar.xaxis")
            }
        }.tint(AppTheme.pink)
    }

    // MARK: - KARTA WYNIKU (TYLKO PREZENTACJA)
    private func optionCard(_ option: PollOption, in poll: MeetingPoll) -> some View {
        let count = poll.countVotes(forOptionID: option.id)
        let percent = VotingService.percent(for: option, in: poll)
        let selected = VotingService.isSelected(option, by: selectedVoter, in: poll)
        return Button {
            guard let meeting else { return }
            store.update(VotingService.castingVote(option.id, by: selectedVoter, in: meeting, pollID: pollID))
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(option.title).font(.headline)
                    Spacer()
                    if selected { Image(systemName: "checkmark.circle.fill").foregroundStyle(AppTheme.pink) }
                    Text("\(count) • \(percent)%").foregroundStyle(AppTheme.textSecondary)
                }
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule().fill(AppTheme.lavender.opacity(0.20))
                        Capsule().fill(AppTheme.mainGradient).frame(width: g.size.width * CGFloat(percent) / 100)
                    }
                }.frame(height: 10)
            }
            .foregroundStyle(AppTheme.textPrimary)
            .slayCard()
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(selected ? AppTheme.pink : .clear, lineWidth: 2))
        }.buttonStyle(.plain)
    }
}
