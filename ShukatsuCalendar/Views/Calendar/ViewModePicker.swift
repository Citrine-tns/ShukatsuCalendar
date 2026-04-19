import SwiftUI

struct ViewModePicker: View {
    @Binding var selection: CalendarViewMode

    var body: some View {
        Picker("表示", selection: $selection) {
            ForEach(CalendarViewMode.allCases) { mode in
                Text(mode.displayName).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
}
