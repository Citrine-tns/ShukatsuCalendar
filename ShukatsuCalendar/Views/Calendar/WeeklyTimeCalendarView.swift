import SwiftUI

struct WeeklyTimeCalendarView: View {
    @EnvironmentObject var store: EventStore
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    @Binding var selectedEvent: JobEvent?

    private let calendar = Calendar.current
    private let startHour = 8
    private let endHour = 20
    private let hourHeight: CGFloat = 60
    private let timeColumnWidth: CGFloat = 44
    private let headerHeight: CGFloat = 44
    private let allDayAreaHeight: CGFloat = 44

    var body: some View {
        GeometryReader { geometry in
            let weekDates = makeWeekDates(for: currentDate)
            let availableWidth = geometry.size.width - timeColumnWidth
            let dayColumnWidth = max(availableWidth / 7, 40)

            ScrollView(.vertical) {
                HStack(alignment: .top, spacing: 0) {
                    timeColumn

                    HStack(spacing: 0) {
                        ForEach(weekDates, id: \.self) { date in
                            DayTimeColumnView(
                                date: date,
                                timedEvents: store.timedEvents(for: date),
                                allDayEvents: store.allDayEvents(for: date),
                                startHour: startHour,
                                endHour: endHour,
                                hourHeight: hourHeight,
                                columnWidth: dayColumnWidth,
                                onSelectEvent: { event in
                                    selectedEvent = event
                                },
                                onSelectDate: { tappedDate in
                                    selectedDate = tappedDate
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    private var timeColumn: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.clear)
                .frame(width: timeColumnWidth, height: headerHeight)

            VStack {
                Text("終日")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: timeColumnWidth, height: allDayAreaHeight)

            ForEach(startHour..<endHour, id: \.self) { hour in
                Text(String(format: "%02d:00", hour))
                    .font(.caption2)
                    .frame(width: timeColumnWidth, height: hourHeight, alignment: .topTrailing)
            }
        }
    }

    private func makeWeekDates(for date: Date) -> [Date] {
        let weekday = calendar.component(.weekday, from: date)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: date) ?? date

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
}
