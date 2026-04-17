import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 16) {
                    Text("就活カレンダー")
                        .font(.largeTitle)
                        .bold()

                    Text("テスト版")
                        .foregroundStyle(.secondary)

                    Text("まずはここから作っていく")
                }
                .padding()
                .navigationTitle("カレンダー")
            }
            .tabItem {
                Label("カレンダー", systemImage: "calendar")
            }

            NavigationStack {
                Text("一覧画面")
                    .navigationTitle("一覧")
            }
            .tabItem {
                Label("一覧", systemImage: "list.bullet")
            }

            NavigationStack {
                Text("設定画面")
                    .navigationTitle("設定")
            }
            .tabItem {
                Label("設定", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    ContentView()
}
