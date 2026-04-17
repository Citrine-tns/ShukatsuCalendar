import SwiftUI

struct DayTimeColumnView: View {
    let date: Date
    let timedEvents: [JobEvent]
    let allDayEvents: [JobEvent]
    let startHour: Int
    let endHour: Int
    let hourHeight: CGFloat
    let columnWidth: CGFloat
    let onSelectEvent: (JobEvent) -> Void
    let onSelectDate: (Date) -> Void

    private let calendar = Calendar.current
    private let headerHeight: CGFloat = 44
    private let allDayAreaMinHeight: CGFloat = 44

    var body: some View {
        let allDayAreaHeight = max(CGFloat(max(allDayEvents.count, 1)) * 24 + 8, allDayAreaMinHeight)

        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Button {
                    onSelectDate(date)
                } label: {
                    VStack(spacing: 4) {
                        Text(dayHeaderText(date))
                            .font(.caption)
                            .bold()

                        Text(dayNumberText(date))
                            .font(.headline)
                    }
                    .frame(width: columnWidth, height: headerHeight)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {
                    if allDayEvents.isEmpty {
                        Text("終日予定なし")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.top, 4)
                    } else {
                        ForEach(allDayEvents) { event in
                            Button {
                                onSelectEvent(event)
                            } label: {
                                Text(event.title)
                                    .font(.caption2)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 3)
                                    .background(event.type.color.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(width: columnWidth, height: allDayAreaHeight, alignment: .topLeading)
                .padding(.horizontal, 4)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                }

                ForEach(startHour..<endHour, id: \.self) { _ in
                    Rectangle()
                        .stroke(Color.gray.opacity(0.18), lineWidth: 0.5)
                        .frame(width: columnWidth, height: hourHeight)
                }
            }

            ForEach(timedEvents) { event in
                let top = yOffset(for: event.startDate) + headerHeight + allDayAreaHeight
                let height = max(eventHeight(for: event.startDate, end: event.endDate), 28)

                Button {
                    onSelectEvent(event)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.caption)
                            .bold()
                            .lineLimit(2)

                        Text(timeRangeText(for: event))
                            .font(.caption2)
                            .lineLimit(1)

                        Text(event.companyName)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .foregroundStyle(.primary)
                    .padding(4)
                    .frame(width: columnWidth - 8, height: height, alignment: .topLeading)
                    .background(event.type.color.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .offset(x: 4, y: top)
            }
        }
        .frame(width: columnWidth, alignment: .top)
    }

    private func yOffset(for date: Date) -> CGFloat {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let totalHours = CGFloat(hour - startHour) + CGFloat(minute) / 60
        return max(totalHours, 0) * hourHeight
    }

    private func eventHeight(for start: Date, end: Date) -> CGFloat {
        let interval = max(end.timeIntervalSince(start), 1800)
        let hours = CGFloat(interval / 3600)
        return hours * hourHeight
    }

    private func dayHeaderText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    private func dayNumberText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func timeRangeText(for event: JobEvent) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "HH:mm"

        return "\(formatter.string(from: event.startDate))〜\(formatter.string(from: event.endDate))"
    }
}
