import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CalendarScreen()
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }

            ScheduleListScreen()
                .tabItem {
                    Label("一覧", systemImage: "list.bullet")
                }

            SettingsScreen()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EventStore())
}
