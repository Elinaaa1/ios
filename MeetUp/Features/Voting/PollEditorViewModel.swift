import Foundation
import Combine

// MARK: - JEDNO POLE ODPOWIEDZI
// Stabilne id zapewnia poprawne dzialanie TextField podczas dodawania/usuwania.
struct DraftPollOption: Identifiable {
    var id = UUID()
    var title = ""
}

// MARK: - LOGIKA FORMULARZA ANKIETY
// View nie sprawdza poprawnosci odpowiedzi ani nie buduje modelu MeetingPoll.
@MainActor
final class PollEditorViewModel: ObservableObject {
    @Published var question = ""
    @Published var kind: PollKind = .date
    @Published var options: [DraftPollOption] = [DraftPollOption(), DraftPollOption()]

    // MARK: - DYNAMICZNA LICZBA ODPOWIEDZI
    func addOption() { options.append(DraftPollOption()) }
    func removeOption(id: UUID) {
        guard options.count > 2 else { return }
        options.removeAll { $0.id == id }
    }

    private var cleaned: [String] {
        options.map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    // MARK: - WALIDACJA: minimum 2, brak pustych i powtarzajacych sie odpowiedzi
    var canSave: Bool {
        let names = cleaned
        return !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               names.count >= 2 && names.allSatisfy { !$0.isEmpty } &&
               Set(names.map { $0.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current) }).count == names.count
    }

    // MARK: - BUDOWANIE ANKIETY (BEZ ZAPISU W BAZIE)
    func makePoll() -> MeetingPoll? {
        guard canSave else { return nil }
        return MeetingPoll(
            question: question.trimmingCharacters(in: .whitespacesAndNewlines),
            kind: kind,
            options: cleaned.map { PollOption(title: $0) }
        )
    }
}
