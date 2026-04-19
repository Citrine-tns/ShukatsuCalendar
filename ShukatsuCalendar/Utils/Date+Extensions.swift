import Foundation

extension Date {
    func startOfMonth(in calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }

    func startOfWeek(in calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}

extension Calendar {
    /// 月表示のグリッドに並べる日付を返す (6週 × 7日 = 42セル)
    func calendarGridDates(for date: Date) -> [Date] {
        let startOfMonth = date.startOfMonth(in: self)
        let firstWeekday = component(.weekday, from: startOfMonth) // 日=1 〜 土=7
        let leadingDays = firstWeekday - 1

        guard let gridStart = self.date(byAdding: .day, value: -leadingDays, to: startOfMonth) else {
            return []
        }

        return (0..<42).compactMap {
            self.date(byAdding: .day, value: $0, to: gridStart)
        }
    }

    func daysOfWeek(containing date: Date) -> [Date] {
        let start = date.startOfWeek(in: self)
        return (0..<7).compactMap {
            self.date(byAdding: .day, value: $0, to: start)
        }
    }
}
