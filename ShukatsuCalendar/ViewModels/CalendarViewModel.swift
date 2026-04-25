import Foundation
import Observation

enum CalendarViewMode: String, CaseIterable, Identifiable {
    case monthly
    case weekly

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .monthly: return "月"
        case .weekly:  return "週"
        }
    }
}

@Observable
final class CalendarViewModel {
    var viewMode: CalendarViewMode = .monthly
    var currentDate: Date = Date()
    var events: [CalendarEvent] = []
    var selectedEvent: CalendarEvent?
    var isLoading = false
    var errorMessage: String?

    private let repository: EventRepository
    private let calendar: Calendar

    init(repository: EventRepository, calendar: Calendar = .current) {
        self.repository = repository
        self.calendar = calendar
    }

    func loadEvents() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            events = try await repository.fetchAllEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func events(on date: Date) -> [CalendarEvent] {
        events
            .filter { calendar.isDate($0.startAt, inSameDayAs: date) }
            .sorted { $0.startAt < $1.startAt }
    }

    func goToPrevious() {
        let component: Calendar.Component = (viewMode == .monthly) ? .month : .weekOfYear
        if let newDate = calendar.date(byAdding: component, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }

    func goToNext() {
        let component: Calendar.Component = (viewMode == .monthly) ? .month : .weekOfYear
        if let newDate = calendar.date(byAdding: component, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }

    func goToToday() {
        currentDate = Date()
    }

    func addEvent(_ event: CalendarEvent) async {
        do {
            try await repository.addEvent(event)
            await loadEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateEvent(_ event: CalendarEvent) async {
        do {
            try await repository.updateEvent(event)
            await loadEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteEvent(id: UUID) async {
        do {
            try await repository.deleteEvent(id: id)
            await loadEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
