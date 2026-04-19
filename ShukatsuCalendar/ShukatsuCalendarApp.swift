import SwiftUI

@main
struct ShukatsuCalendarApp: App {
    private let repository: EventRepository = MockEventRepository()

    var body: some Scene {
        WindowGroup {
            RootTabView(repository: repository)
        }
    }
}
