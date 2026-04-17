import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("アプリ") {
                    Text("就活予定を管理するテスト版")
                }

                Section("今後追加したい機能") {
                    Text("・通知")
                    Text("・会社ごとの絞り込み")
                    Text("・締切順の並び替え")
                    Text("・保存機能")
                }
            }
            .navigationTitle("設定")
        }
    }
}
