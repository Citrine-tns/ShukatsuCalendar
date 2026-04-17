import Foundation
import Combine

final class EventStore: ObservableObject {
    @Published var events: [JobEvent] = [
        JobEvent(
            title: "ES提出",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 20)) ?? Date(),
            type: .deadline,
            companyName: "A社",
            memo: "マイページから提出"
        ),
        JobEvent(
            title: "一次面接",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 22)) ?? Date(),
            type: .interview,
            companyName: "B社",
            memo: "オンライン面接"
        ),
        JobEvent(
            title: "夏インターン締切",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 25)) ?? Date(),
            type: .deadline,
            companyName: "C社",
            memo: "エントリーシート提出"
        ),
        JobEvent(
            title: "会社説明会",
            date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 18)) ?? Date(),
            type: .infoSession,
            companyName: "D社",
            memo: "対面開催"
        )
    ]

    func events(for date: Date) -> [JobEvent] {
        events
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date < $1.date }
    }

    func addEvent(_ event: JobEvent) {
        events.append(event)
        events.sort { $0.date < $1.date }
    }
}
