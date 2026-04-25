import SwiftUI

struct EventDetailSheet: View {
    let event: CalendarEvent
    let onEdit: () -> Void
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Circle()
                            .fill(event.category.color)
                            .frame(width: 10, height: 10)
                        Text(event.category.displayName)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(event.category.color)
                    }

                    Text(event.title)
                        .font(.title2.bold())

                    Label {
                        Text(dateTimeString)
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.subheadline)

                    if let company = event.company {
                        Label {
                            Text(company)
                        } icon: {
                            Image(systemName: "building.2")
                        }
                        .font(.subheadline)
                    }

                    if let description = event.eventDescription, !description.isEmpty {
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("詳細")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Text(description).font(.body)
                        }
                    }

                    if let url = event.url {
                        Divider()
                        Link(destination: url) {
                            Label("応募ページを開く", systemImage: "arrow.up.right.square")
                        }
                    }

                    Divider()
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("この予定を削除", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .padding(.top, 8)

                    Spacer(minLength: 0)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("予定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("編集") { onEdit() }
                }
            }
            .confirmationDialog(
                "この予定を削除しますか？",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("削除", role: .destructive) {
                    onDelete()
                }
                Button("キャンセル", role: .cancel) {}
            }
        }
    }

    private var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")

        if event.isAllDay {
            formatter.dateFormat = "yyyy年M月d日(E) 終日"
            return formatter.string(from: event.startAt)
        }

        formatter.dateFormat = "yyyy年M月d日(E) HH:mm"
        var result = formatter.string(from: event.startAt)
        if let end = event.endAt {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            result += " - " + timeFormatter.string(from: end)
        }
        return result
    }
}
