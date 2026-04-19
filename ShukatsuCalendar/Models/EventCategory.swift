import SwiftUI

enum EventCategory: String, Codable, CaseIterable, Identifiable {
    case internshipDeadline
    case interview
    case personal
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .internshipDeadline: return "インターン締切"
        case .interview:          return "面接"
        case .personal:           return "個人"
        case .other:              return "その他"
        }
    }

    var color: Color {
        switch self {
        case .internshipDeadline: return .red
        case .interview:          return .orange
        case .personal:           return .blue
        case .other:              return .gray
        }
    }
}
