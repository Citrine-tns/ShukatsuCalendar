import SwiftUI

struct ScheduleListScreen: View {
    @EnvironmentObject var store: EventStore

    var body: some View {
        NavigationStack {
            List {
                if store.events.isEmpty {
                    Text("予定がありません")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.events.sorted(by: { $0.date < $1.date })) { event in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(event.type.color)
                                    .frame(width: 10, height: 10)

                                Text(event.title)
                                    .font(.headline)
                            }

                            Text("\(event.companyName) ・ \(event.type.rawValue)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(event.date.formatted(date: .long, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("一覧")
        }
    }
}
