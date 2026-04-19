import SwiftUI

struct RootTabView: View {
    @State private var calendarVM: CalendarViewModel
    @State private var internshipVM: InternshipListViewModel

    init(repository: EventRepository) {
        _calendarVM   = State(initialValue: CalendarViewModel(repository: repository))
        _internshipVM = State(initialValue: InternshipListViewModel(repository: repository))
    }

    var body: some View {
        TabView {
            CalendarScreen(viewModel: calendarVM)
                .tabItem { Label("カレンダー", systemImage: "calendar") }

            InternshipListScreen(viewModel: internshipVM)
                .tabItem { Label("締切一覧", systemImage: "list.bullet.clipboard") }
        }
    }
}
