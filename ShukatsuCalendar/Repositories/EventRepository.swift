import Foundation

protocol EventRepository {
    func fetchAllEvents() async throws -> [CalendarEvent]
    func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent]
    func fetchUpcomingInternshipDeadlines(limit: Int) async throws -> [CalendarEvent]
}
