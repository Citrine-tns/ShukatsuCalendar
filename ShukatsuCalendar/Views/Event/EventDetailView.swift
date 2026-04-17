import SwiftUI

struct EventDetailView: View {
    let event: JobEvent

    var body: some View {
        NavigationStack {
            List {
                Section("タイトル") {
                    Text(event.title)
                }

                Section("会社名") {
                    Text(event.companyName)
                }

                Section("種類") {
                    HStack {
                        Circle()
                            .fill(event.type.color)
                            .frame(width: 10, height: 10)

                        Text(event.type.rawValue)
                    }
                }

                Section("日付") {
                    Text(event.date.formatted(date: .long, time: .omitted))
                }

                Section("メモ") {
                    Text(event.memo.isEmpty ? "なし" : event.memo)
                }
            }
            .navigationTitle("予定詳細")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
