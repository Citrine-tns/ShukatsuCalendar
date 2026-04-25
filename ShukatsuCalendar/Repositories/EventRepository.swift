import Foundation

protocol EventRepository {
    func fetchAllEvents() async throws -> [CalendarEvent]
    func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent]
    func fetchUpcomingInternshipDeadlines(limit: Int) async throws -> [CalendarEvent]

    func addEvent(_ event: CalendarEvent) async throws
    func updateEvent(_ event: CalendarEvent) async throws
    func deleteEvent(id: UUID) async throws
}
