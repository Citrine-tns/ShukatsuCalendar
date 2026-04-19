import SwiftUI

struct WeeklyView: View {
    let currentDate: Date
    let events: [CalendarEvent]
    let onSelectEvent: (CalendarEvent) -> Void

    private let calendar = Calendar.current

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(calendar.daysOfWeek(containing: currentDate), id: \.self) { date in
                    WeeklyDayRow(
                        date: date,
                        events: eventsFor(date),
                        onSelectEvent: onSelectEvent
                    )
                }
            }
            .padding()
        }
    }

    private func eventsFor(_ date: Date) -> [CalendarEvent] {
        events
            .filter { calendar.isDate($0.startAt, inSameDayAs: date) }
            .sorted { $0.startAt < $1.startAt }
    }
}

private struct WeeklyDayRow: View {
    let date: Date
    let events: [CalendarEvent]
    let onSelectEvent: (CalendarEvent) -> Void

    private let calendar = Calendar.current

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.title3.bold())
                    .foregroundStyle(dayColor)
                Text(weekdayString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if calendar.isDateInToday(date) {
                    Text("今日")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
                Spacer()
            }

            if events.isEmpty {
                Text("予定なし")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
            } else {
                ForEach(events) { event in
                    Button { onSelectEvent(event) } label: {
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(event.category.color)
                                .frame(width: 4)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Text(timeString(for: event))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }

    private var weekdayString: String {
        let symbols = ["日", "月", "火", "水", "木", "金", "土"]
        let weekday = calendar.component(.weekday, from: date)
        return symbols[weekday - 1] + "曜日"
    }

    private var dayColor: Color {
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 1 { return .red }
        if weekday == 7 { return .blue }
        return .primary
    }

    private func timeString(for event: CalendarEvent) -> String {
        if event.isAllDay { return "終日" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var result = formatter.string(from: event.startAt)
        if let end = event.endAt {
            result += " - " + formatter.string(from: end)
        }
        return result
    }
}
