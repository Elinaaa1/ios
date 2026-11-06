// MARK: - LOGIKA GLOSOWANIA
// Modele ankiety, liczenie glosow, remis oraz zmiana glosu.

import Foundation

// Kazdy uczestnik ma jeden glos w ankiecie; ponowne glosowanie zmienia wybor.
// Pojedyncza odpowiedz, np. "Cafe".
struct PollOption: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
}

// Zapis informacji, kto zaglosowal i na ktora odpowiedz.
struct PollVote: Codable, Equatable {
    var voterName: String
    var optionID: UUID
}

// Rodzaj ankiety: data, miejsce lub aktywnosc.
enum PollKind: String, CaseIterable, Codable, Identifiable {
    case date = "Date"
    case location = "Location"
    case activity = "Activity"

    var id: String { rawValue }
}

// Cala ankieta przypisana do wydarzenia.
struct MeetingPoll: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var question: String
    var kind: PollKind
    var options: [PollOption]
    var votes: [PollVote] = []

    // MARK: - 1. LICZENIE GLOSOW NA JEDNA ODPOWIEDZ
    func countVotes(forOptionID id: UUID) -> Int {
        votes.filter { $0.optionID == id }.count
    }

    // MARK: - 2. NAJWIEKSZA LICZBA GLOSOW
    var maximumVoteCount: Int {
        options.map { countVotes(forOptionID: $0.id) }.max() ?? 0
    }

    // MARK: - 3. WYGRYWAJACE ODPOWIEDZI (MOZLIWY REMIS)
    var winningOptions: [PollOption] {
        guard maximumVoteCount > 0 else { return [] }
        return options.filter { countVotes(forOptionID: $0.id) == maximumVoteCount }
    }

    // MARK: - 4. TEKST WYNIKU
    var resultText: String {
        if votes.isEmpty { return "No votes yet" }
        if winningOptions.count > 1 { return "Tie: " + winningOptions.map(\.title).joined(separator: ", ") }
        return "Leading: " + (winningOptions.first?.title ?? "—")
    }

    // MARK: - 5. ZAPIS LUB ZMIANA GLOSU
    mutating func castVote(voterName: String, optionID: UUID) {
        guard options.contains(where: { $0.id == optionID }) else { return }
        guard !voterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // Usuwamy poprzedni glos tej osoby, aby nie glosowala dwa razy.
        votes.removeAll { $0.voterName == voterName }
        votes.append(PollVote(voterName: voterName, optionID: optionID))
    }
}
