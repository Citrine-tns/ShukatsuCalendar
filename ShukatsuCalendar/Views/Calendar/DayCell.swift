import SwiftUI

struct DayCell: View {
    let date: Date
    let isInCurrentMonth: Bool
    let events: [CalendarEvent]
    let onSelectEvent: (CalendarEvent) -> Void

    private let calendar = Calendar.current

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(calendar.component(.day, from: date))")
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(isToday ? .white : textColor)
                .frame(width: 20, height: 20)
                .background(
                    Circle().fill(isToday ? Color.accentColor : .clear)
                )
                .padding(.top, 2)
                .padding(.leading, 2)

            ForEach(events.prefix(3)) { event in
                Button {
                    onSelectEvent(event)
                } label: {
                    Text(event.title)
                        .font(.system(size: 9))
                        .lineLimit(1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(event.category.color.opacity(isInCurrentMonth ? 0.9 : 0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 2)
            }

            if events.count > 3 {
                Text("+\(events.count - 3)")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    private var textColor: Color {
        if !isInCurrentMonth { return .secondary }
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 1 { return .red }
        if weekday == 7 { return .blue }
        return .primary
    }
}
