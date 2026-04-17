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

                Section("日時") {
                    if event.isAllDay {
                        Text(event.startDate.formatted(date: .long, time: .omitted))
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.startDate.formatted(date: .long, time: .shortened))
                            Text("〜")
                            Text(event.endDate.formatted(date: .long, time: .shortened))
                        }
                    }
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
