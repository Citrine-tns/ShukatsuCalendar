import Foundation
import Combine

final class EventStore: ObservableObject {
    @Published var events: [JobEvent] = [
        JobEvent(
            title: "ES提出",
            startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 20, hour: 23, minute: 59)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 20, hour: 23, minute: 59)) ?? Date(),
            isAllDay: true,
            type: .deadline,
            companyName: "A社",
            memo: "マイページから提出"
        ),
        JobEvent(
            title: "一次面接",
            startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 22, hour: 10, minute: 0)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 22, hour: 11, minute: 0)) ?? Date(),
            isAllDay: false,
            type: .interview,
            companyName: "B社",
            memo: "オンライン面接"
        ),
        JobEvent(
            title: "会社説明会",
            startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 24, hour: 13, minute: 0)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 24, hour: 14, minute: 30)) ?? Date(),
            isAllDay: false,
            type: .infoSession,
            companyName: "C社",
            memo: "対面開催"
        )
    ]

    func events(for date: Date) -> [JobEvent] {
        events
            .filter { Calendar.current.isDate($0.startDate, inSameDayAs: date) }
            .sorted { $0.startDate < $1.startDate }
    }

    func timedEvents(for date: Date) -> [JobEvent] {
        events(for: date).filter { !$0.isAllDay }
    }

    func allDayEvents(for date: Date) -> [JobEvent] {
        events(for: date).filter { $0.isAllDay }
    }

    func addEvent(_ event: JobEvent) {
        events.append(event)
        events.sort { $0.startDate < $1.startDate }
    }
}
