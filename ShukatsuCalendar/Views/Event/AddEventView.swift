import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: EventStore

    let defaultDate: Date

    @State private var title: String = ""
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var isAllDay: Bool = true
    @State private var type: EventType = .deadline
    @State private var companyName: String = ""
    @State private var memo: String = ""

    init(defaultDate: Date) {
        self.defaultDate = defaultDate

        let start = Calendar.current.date(
            bySettingHour: 9,
            minute: 0,
            second: 0,
            of: defaultDate
        ) ?? defaultDate

        let end = Calendar.current.date(
            bySettingHour: 10,
            minute: 0,
            second: 0,
            of: defaultDate
        ) ?? defaultDate.addingTimeInterval(3600)

        _startDate = State(initialValue: start)
        _endDate = State(initialValue: end)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("タイトル", text: $title)
                    TextField("会社名", text: $companyName)
                }

                Section("日時") {
                    Toggle("終日", isOn: $isAllDay)

                    if isAllDay {
                        DatePicker("日付", selection: $startDate, displayedComponents: .date)
                    } else {
                        DatePicker("開始", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("終了", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }

                Section("種類") {
                    Picker("種類", selection: $type) {
                        ForEach(EventType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section("メモ") {
                    TextField("メモ", text: $memo, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("予定追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        saveEvent()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
            .onChange(of: startDate) { _, newValue in
                if endDate < newValue {
                    endDate = newValue.addingTimeInterval(3600)
                }
            }
        }
    }

    private func saveEvent() {
        let finalStart: Date
        let finalEnd: Date

        if isAllDay {
            finalStart = Calendar.current.startOfDay(for: startDate)
            finalEnd = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: startDate) ?? startDate
        } else {
            finalStart = startDate
            finalEnd = max(endDate, startDate.addingTimeInterval(1800))
        }

        let newEvent = JobEvent(
            title: title,
            startDate: finalStart,
            endDate: finalEnd,
            isAllDay: isAllDay,
            type: type,
            companyName: companyName,
            memo: memo
        )

        store.addEvent(newEvent)
        dismiss()
    }
}
