import Foundation

final class MockEventRepository: EventRepository {
    private var events: [CalendarEvent]

    init() {
        let calendar = Calendar.current
        let now = Date()

        func date(daysFromNow days: Int, hour: Int = 23, minute: Int = 59) -> Date {
            let base = calendar.date(byAdding: .day, value: days, to: now) ?? now
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? base
        }

        self.events = [
            CalendarEvent(
                title: "ABC商事 サマーインターン 応募締切",
                category: .internshipDeadline,
                startAt: date(daysFromNow: 3),
                isAllDay: true,
                company: "ABC商事",
                eventDescription: "3daysサマーインターン。ES + 適性検査。",
                url: URL(string: "https://example.com/abc")
            ),
            CalendarEvent(
                title: "XYZテック エンジニアインターン 締切",
                category: .internshipDeadline,
                startAt: date(daysFromNow: 7),
                isAllDay: true,
                company: "XYZテック",
                eventDescription: "1週間のエンジニア体験。コーディングテストあり。",
                url: URL(string: "https://example.com/xyz")
            ),
            CalendarEvent(
                title: "○○銀行 一次面接",
                category: .interview,
                startAt: date(daysFromNow: 5, hour: 14, minute: 0),
                endAt: date(daysFromNow: 5, hour: 15, minute: 0),
                company: "○○銀行",
                eventDescription: "オンライン面接。Zoomリンクは前日共有。"
            ),
            CalendarEvent(
                title: "研究室ミーティング",
                category: .personal,
                startAt: date(daysFromNow: 1, hour: 10, minute: 0),
                endAt: date(daysFromNow: 1, hour: 12, minute: 0),
                eventDescription: "週次進捗報告"
            ),
            CalendarEvent(
                title: "DEF商社 ES締切",
                category: .internshipDeadline,
                startAt: date(daysFromNow: 10),
                isAllDay: true,
                company: "DEF商社"
            ),
            CalendarEvent(
                title: "技術書読書会",
                category: .personal,
                startAt: date(daysFromNow: 2, hour: 19, minute: 0),
                endAt: date(daysFromNow: 2, hour: 21, minute: 0)
            ),
            CalendarEvent(
                title: "GHI株式会社 最終面接",
                category: .interview,
                startAt: date(daysFromNow: 14, hour: 10, minute: 0),
                endAt: date(daysFromNow: 14, hour: 11, minute: 30),
                company: "GHI株式会社"
            ),
            CalendarEvent(
                title: "JKLスタートアップ インターン締切",
                category: .internshipDeadline,
                startAt: date(daysFromNow: 21),
                isAllDay: true,
                company: "JKLスタートアップ"
            ),
            CalendarEvent(
                title: "MNO Inc. 締切(過去)",
                category: .internshipDeadline,
                startAt: date(daysFromNow: -2),
                isAllDay: true,
                company: "MNO Inc.",
                eventDescription: "(締切済みサンプル)"
            ),
            CalendarEvent(
                title: "友人との食事",
                category: .other,
                startAt: date(daysFromNow: 4, hour: 19, minute: 0),
                endAt: date(daysFromNow: 4, hour: 21, minute: 0)
            )
        ]
    }

    func fetchAllEvents() async throws -> [CalendarEvent] {
        events
    }

    func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent] {
        events.filter { range.contains($0.startAt) }
    }

    func fetchUpcomingInternshipDeadlines(limit: Int) async throws -> [CalendarEvent] {
        events
            .filter { $0.category == .internshipDeadline && $0.startAt > Date() }
            .sorted { $0.startAt < $1.startAt }
            .prefix(limit)
            .map { $0 }
    }

    func addEvent(_ event: CalendarEvent) async throws {
        events.append(event)
    }

    func updateEvent(_ event: CalendarEvent) async throws {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
    }

    func deleteEvent(id: UUID) async throws {
        events.removeAll { $0.id == id }
    }
}
