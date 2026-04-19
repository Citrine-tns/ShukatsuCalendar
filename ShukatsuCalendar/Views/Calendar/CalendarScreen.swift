import SwiftUI

struct CalendarScreen: View {
    @Bindable var viewModel: CalendarViewModel

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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("今日") { viewModel.goToToday() }
                }
            }
            .task { await viewModel.loadEvents() }
            .sheet(item: $viewModel.selectedEvent) { event in
                EventDetailSheet(event: event)
            }
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
        formatter.dateFormat = (viewModel.viewMode == .monthly) ? "yyyy年M月" : "yyyy年M月d日の週"
        return formatter.string(from: viewModel.currentDate)
    }
}
