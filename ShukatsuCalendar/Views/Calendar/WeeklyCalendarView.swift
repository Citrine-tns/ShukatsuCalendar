import SwiftUI

struct WeeklyCalendarView: View {
    @EnvironmentObject var store: EventStore

    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Binding var selectedEvent: JobEvent?

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        let weekDates = makeWeekDates(for: currentDate)

        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(weekDates, id: \.self) { date in
                VStack(spacing: 6) {
                    Text(weekdaySymbol(for: date))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    DayCellView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        events: store.events(for: date)
                    )
                }
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
    }

    private func makeWeekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: date) ?? date

        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }

    private func weekdaySymbol(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
