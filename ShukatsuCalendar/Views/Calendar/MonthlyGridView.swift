import SwiftUI

struct MonthlyGridView: View {
    let currentDate: Date
    let events: [CalendarEvent]
    let onSelectEvent: (CalendarEvent) -> Void

    private let calendar = Calendar.current
    private let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        VStack(spacing: 0) {
            // 曜日ヘッダ
            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { i in
                    Text(weekdaySymbols[i])
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(weekdayColor(for: i))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 6)
            .background(Color(.systemGroupedBackground))

            // 日付グリッド
            let gridDates = calendar.calendarGridDates(for: currentDate)
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(gridDates, id: \.self) { date in
                    DayCell(
                        date: date,
                        isInCurrentMonth: calendar.isDate(date, equalTo: currentDate, toGranularity: .month),
                        events: eventsFor(date),
                        onSelectEvent: onSelectEvent
                    )
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 80)
                    .border(Color(.separator).opacity(0.5), width: 0.5)
                }
            }

            Spacer()
        }
    }

    private func eventsFor(_ date: Date) -> [CalendarEvent] {
        events
            .filter { calendar.isDate($0.startAt, inSameDayAs: date) }
            .sorted { $0.startAt < $1.startAt }
    }

    private func weekdayColor(for index: Int) -> Color {
        switch index {
        case 0: return .red
        case 6: return .blue
        default: return .primary
        }
    }
}
