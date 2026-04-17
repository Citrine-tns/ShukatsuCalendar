import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: EventStore

    let defaultDate: Date

    @State private var title: String = ""
    @State private var date: Date
    @State private var type: EventType = .deadline
    @State private var companyName: String = ""
    @State private var memo: String = ""

    init(defaultDate: Date) {
        self.defaultDate = defaultDate
        _date = State(initialValue: defaultDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("タイトル", text: $title)
                    TextField("会社名", text: $companyName)
                    DatePicker("日付", selection: $date, displayedComponents: .date)
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
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveEvent() {
        let newEvent = JobEvent(
            title: title,
            date: date,
            type: type,
            companyName: companyName,
            memo: memo
        )
        store.addEvent(newEvent)
        dismiss()
    }
}
