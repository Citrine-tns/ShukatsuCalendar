import Foundation
import Observation

@Observable
final class InternshipListViewModel {
    var deadlines: [CalendarEvent] = []
    var selectedEvent: CalendarEvent?
    var isLoading = false
    var errorMessage: String?

    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            deadlines = try await repository.fetchUpcomingInternshipDeadlines(limit: 50)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: now, to: target).day ?? 0
    }
}
