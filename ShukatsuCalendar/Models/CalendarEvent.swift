import Foundation

enum EventSource: String, Codable {
    case manual
    case scraped   // 将来用
    case imported  // 将来用
}

struct CalendarEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var category: EventCategory
    var startAt: Date
    var endAt: Date?
    var isAllDay: Bool
    var company: String?
    var eventDescription: String?   // [description]はNSObjectと衝突する
    var url: URL?
    var source: EventSource

    init(
        id: UUID = UUID(),
        title: String,
        category: EventCategory,
        startAt: Date,
        endAt: Date? = nil,
        isAllDay: Bool = false,
        company: String? = nil,
        eventDescription: String? = nil,
        url: URL? = nil,
        source: EventSource = .manual
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startAt = startAt
        self.endAt = endAt
        self.isAllDay = isAllDay
        self.company = company
        self.eventDescription = eventDescription
        self.url = url
        self.source = source
    }
}
