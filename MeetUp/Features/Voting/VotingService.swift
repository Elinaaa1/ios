import Foundation

// MARK: - FUNKCJE GLOSOWANIA I WYNIKOW
struct VotingService {
    static func percent(for option: PollOption, in poll: MeetingPoll) -> Int {
        guard !poll.votes.isEmpty else { return 0 }
        return Int((Double(poll.countVotes(forOptionID: option.id)) / Double(poll.votes.count) * 100).rounded())
    }
    static func isSelected(_ option: PollOption, by voter: String, in poll: MeetingPoll) -> Bool {
        poll.votes.contains { $0.optionID == option.id && $0.voterName == voter }
    }
    static func castingVote(_ optionID: UUID, by voter: String, in meeting: Meeting, pollID: UUID) -> Meeting {
        var updated = meeting
        if let index = updated.polls.firstIndex(where: { $0.id == pollID }) {
            updated.polls[index].castVote(voterName: voter, optionID: optionID)
        }
        return updated
    }
    static func deletingPoll(_ pollID: UUID, from meeting: Meeting) -> Meeting {
        var updated = meeting
        updated.polls.removeAll { $0.id == pollID }
        return updated
    }
}
