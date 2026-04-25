import SwiftUI

struct InternshipListScreen: View {
    @Bindable var viewModel: InternshipListViewModel

    @State private var pendingEditEvent: CalendarEvent?
    @State private var editingEvent: CalendarEvent?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.deadlines.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "締切なし",
                        systemImage: "tray",
                        description: Text("今後のインターン締切はありません")
                    )
                } else {
                    List(viewModel.deadlines) { event in
                        Button {
                            viewModel.selectedEvent = event
                        } label: {
                            DeadlineRow(event: event, daysUntil: viewModel.daysUntil(event.startAt))
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("インターン締切")
            .task { await viewModel.load() }
            .onAppear { Task { await viewModel.load() } }
            .sheet(item: $viewModel.selectedEvent, onDismiss: handleDetailDismiss) { event in
                EventDetailSheet(
                    event: event,
                    onEdit: {
                        pendingEditEvent = event
                        viewModel.selectedEvent = nil
                    },
                    onDelete: {
                        let id = event.id
                        viewModel.selectedEvent = nil
                        Task { await viewModel.deleteEvent(id: id) }
                    }
                )
            }
            .sheet(item: $editingEvent) { event in
                EventEditorSheet(
                    mode: .edit(event),
                    onSave: { updated in
                        Task { await viewModel.updateEvent(updated) }
                    }
                )
            }
        }
    }

    private func handleDetailDismiss() {
        if let pending = pendingEditEvent {
            editingEvent = pending
            pendingEditEvent = nil
        }
    }
}

private struct DeadlineRow: View {
    let event: CalendarEvent
    let daysUntil: Int

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 2) {
                Text("\(daysUntil)")
                    .font(.title.bold())
                    .foregroundStyle(urgencyColor)
                Text("日後")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50)

            Rectangle()
                .fill(event.category.color)
                .frame(width: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                if let company = event.company {
                    Text(company)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(dateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private var urgencyColor: Color {
        switch daysUntil {
        case ...3: return .red
        case 4...7: return .orange
        default:   return .primary
        }
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: event.startAt)
    }
}
