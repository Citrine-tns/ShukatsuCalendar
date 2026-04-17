import SwiftUI

struct MonthlyCalendarView: View {
    @EnvironmentObject var store: EventStore

    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Binding var selectedEvent: JobEvent?

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekSymbols = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        let dates = makeMonthDates(for: currentDate)

        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(weekSymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption)
                    .bold()
                    .frame(maxWidth: .infinity)
            }

            ForEach(Array(dates.enumerated()), id: \.offset) { _, date in
                if let date {
                    DayCellView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        events: store.events(for: date)
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                } else {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 56)
                }
            }
        }
    }

    private func makeMonthDates(for date: Date) -> [Date?] {
        let calendar = Calendar.current

        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return []
        }

        let firstDay = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let startPadding = firstWeekday - 1
        let numberOfDays = calendar.range(of: .day, in: .month, for: date)?.count ?? 0

        var result: [Date?] = Array(repeating: nil, count: startPadding)

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)

        for day in 1...numberOfDays {
            let components = DateComponents(year: year, month: month, day: day)
            if let dayDate = calendar.date(from: components) {
                result.append(dayDate)
            }
        }

        while result.count % 7 != 0 {
            result.append(nil)
        }

        return result
    }
}
