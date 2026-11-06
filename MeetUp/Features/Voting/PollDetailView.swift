// MARK: - GLOSOWANIE I WYNIKI
// Wyswietla opcje, oddaje glos i pokazuje procenty.

import SwiftUI

struct PollDetailView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    let meetingID: UUID
    let pollID: UUID
    @State private var selectedVoter = "Me"

    private var meeting: Meeting? {
        store.meetings.first { $0.id == meetingID }
    }

    private var poll: MeetingPoll? {
        meeting?.polls.first { $0.id == pollID }
    }

    private var voters: [String] {
        ["Me"] + (meeting?.participantNames.filter { $0 != "Me" } ?? [])
    }

    var body: some View {
        Group {
            if let poll {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(poll.kind.rawValue.uppercased())
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.pink)
                            Text(poll.question)
                                .font(.title2.bold())
                            Text("\(poll.votes.count) vote(s) • One choice per person")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(AppTheme.mainGradient.opacity(0.15), in: RoundedRectangle(cornerRadius: 22))

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Voting as")
                                .font(.headline)
                            Picker("Person", selection: $selectedVoter) {
                                ForEach(voters, id: \.self) { name in
                                    Text(name).tag(name)
                                }
                            }
                            .pickerStyle(.menu)
                            Text("Demo mode: select a participant to submit their vote on this device.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(spacing: 12) {
                            ForEach(poll.options) { option in
                                optionCard(option, poll: poll)
                            }
                        }

                        Label(poll.resultText, systemImage: "chart.bar.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.textPrimary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white, in: RoundedRectangle(cornerRadius: 16))

                        Button("Delete poll", role: .destructive) {
                            deletePoll()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    }
                    .padding()
                }
                .background(AppTheme.background.ignoresSafeArea())
                .navigationTitle("Poll results")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Poll unavailable", systemImage: "exclamationmark.bubble")
            }
        }
        .tint(AppTheme.pink)
    }

    // MARK: - WIDOK JEDNEJ ODPOWIEDZI I PASKA PROCENTOWEGO
    private func optionCard(_ option: PollOption, poll: MeetingPoll) -> some View {
        let count = poll.countVotes(forOptionID: option.id)
        // Zabezpieczenie przed dzieleniem przez zero (brak glosow).
        let fraction = poll.votes.isEmpty ? 0.0 : Double(count) / Double(poll.votes.count)
        let isSelected = poll.votes.contains { $0.voterName == selectedVoter && $0.optionID == option.id }

        return Button {
            submitVote(for: option.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(option.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.pink)
                    }
                    Text("\(count) • \(Int((fraction * 100).rounded()))%")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule().fill(AppTheme.lavender.opacity(0.16))
                        Capsule().fill(AppTheme.mainGradient)
                            .frame(width: geometry.size.width * fraction)
                    }
                }
                .frame(height: 9)
            }
            .padding(16)
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AppTheme.pink : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - ODDANIE GLOSU I ZAPIS ZMIAN DO EVENTSTORE
    private func submitVote(for optionID: UUID) {
        guard var updated = meeting,
              let index = updated.polls.firstIndex(where: { $0.id == pollID }) else { return }
        updated.polls[index].castVote(voterName: selectedVoter, optionID: optionID)
        store.update(updated)
    }

    // MARK: - USUNIECIE ANKIETY
    private func deletePoll() {
        guard var updated = meeting else { return }
        updated.polls.removeAll { $0.id == pollID }
        store.update(updated)
        dismiss()
    }
}
