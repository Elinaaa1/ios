import Foundation

// MARK: - OPERACJE NA ZADANIACH WYDARZENIA
struct TaskService {
    static func adding(_ text: String, to meeting: Meeting) -> Meeting? {
        let title = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return nil }
        var updated = meeting
        updated.tasks.append(MeetingTask(title: title))
        return updated
    }
    static func toggling(_ id: UUID, in meeting: Meeting) -> Meeting {
        var updated = meeting
        if let index = updated.tasks.firstIndex(where: { $0.id == id }) {
            updated.tasks[index].isDone.toggle()
        }
        return updated
    }
    static func deleting(at offsets: IndexSet, from meeting: Meeting) -> Meeting {
        var updated = meeting
        updated.tasks.remove(atOffsets: offsets)
        return updated
    }
}
