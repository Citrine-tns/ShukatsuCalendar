import SwiftUI

struct CalendarScreen: View {
    @Bindable var viewModel: CalendarViewModel

    @State private var pendingEditEvent: CalendarEvent?
    @State private var editingEvent: CalendarEvent?
    @State private var isCreating = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                ViewModePicker(selection: $viewModel.viewMode)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                Group {
                    switch viewModel.viewMode {
                    case .monthly:
                        MonthlyGridView(
                            currentDate: viewModel.currentDate,
                            events: viewModel.events,
                            onSelectEvent: { viewModel.selectedEvent = $0 }
                        )
                    case .weekly:
                        WeeklyView(
                            currentDate: viewModel.currentDate,
                            events: viewModel.events,
                            onSelectEvent: { viewModel.selectedEvent = $0 }
                        )
                    }
                }
            }
            .navigationTitle("カレンダー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("今日") { viewModel.goToToday() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { isCreating = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task { await viewModel.loadEvents() }
            .onAppear { Task { await viewModel.loadEvents() } }
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
            .sheet(isPresented: $isCreating) {
                EventEditorSheet(
                    mode: .create(prefilledDate: viewModel.currentDate, prefilledCategory: nil),
                    onSave: { newEvent in
                        Task { await viewModel.addEvent(newEvent) }
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

    private var headerView: some View {
        HStack {
            Button { viewModel.goToPrevious() } label: {
                Image(systemName: "chevron.left").font(.title3)
            }
            Spacer()
            Text(headerTitle).font(.title2.bold())
            Spacer()
            Button { viewModel.goToNext() } label: {
                Image(systemName: "chevron.right").font(.title3)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")

        switch viewModel.viewMode {
        case .monthly:
            formatter.dateFormat = "yyyy年M月"
            return formatter.string(from: viewModel.currentDate)

        case .weekly:
            let weekDates = Calendar.current.daysOfWeek(containing: viewModel.currentDate)

            guard let start = weekDates.first, let end = weekDates.last else {
                formatter.dateFormat = "yyyy年M月d日"
                return formatter.string(from: viewModel.currentDate)
            }

            let startFormatter = DateFormatter()
            startFormatter.locale = Locale(identifier: "ja_JP")

            let endFormatter = DateFormatter()
            endFormatter.locale = Locale(identifier: "ja_JP")

            if Calendar.current.component(.year, from: start) != Calendar.current.component(.year, from: end) {
                startFormatter.dateFormat = "yyyy年M月d日"
                endFormatter.dateFormat = "yyyy年M月d日"
            } else if Calendar.current.component(.month, from: start) != Calendar.current.component(.month, from: end) {
                startFormatter.dateFormat = "M月d日"
                endFormatter.dateFormat = "M月d日"
            } else {
                startFormatter.dateFormat = "M月d日"
                endFormatter.dateFormat = "d日"
            }

            return "\(startFormatter.string(from: start))〜\(endFormatter.string(from: end))"
        }
    }
}
