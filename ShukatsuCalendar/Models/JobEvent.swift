import Foundation
import SwiftUI

enum EventType: String, CaseIterable, Identifiable, Codable {
    case deadline = "締切"
    case interview = "面接"
    case internship = "インターン"
    case infoSession = "説明会"
    case other = "その他"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .deadline:
            return .red
        case .interview:
            return .blue
        case .internship:
            return .green
        case .infoSession:
            return .orange
        case .other:
            return .gray
        }
    }
}

struct JobEvent: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool
    var type: EventType
    var companyName: String
    var memo: String

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        endDate: Date,
        isAllDay: Bool = false,
        type: EventType,
        companyName: String,
        memo: String = ""
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.type = type
        self.companyName = companyName
        self.memo = memo
    }
}
