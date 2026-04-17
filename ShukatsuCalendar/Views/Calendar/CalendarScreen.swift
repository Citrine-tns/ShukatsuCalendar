import SwiftUI

enum CalendarDisplayMode: String, CaseIterable, Identifiable {
    case month = "月"
    case week = "週"

    var id: String { rawValue }
}

struct CalendarScreen: View {
    @EnvironmentObject var store: EventStore

    @State private var displayMode: CalendarDisplayMode = .month
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()
    @State private var selectedEvent: JobEvent?
    @State private var showingAddEventSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("表示", selection: $displayMode) {
                        ForEach(CalendarDisplayMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Button {
                            movePeriod(by: -1)
                        } label: {
                            Image(systemName: "chevron.left")
                        }

                        Spacer()

                        Text(titleText(for: currentDate))
                            .font(.title3)
                            .bold()

                        Spacer()

                        Button {
                            movePeriod(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }

                    if displayMode == .month {
                        MonthlyCalendarView(
                            currentDate: $currentDate,
                            selectedDate: $selectedDate,
                            selectedEvent: $selectedEvent
                        )
                        .environmentObject(store)
                    } else {
                        WeeklyCalendarView(
                            currentDate: $currentDate,
                            selectedDate: $selectedDate,
                            selectedEvent: $selectedEvent
                        )
                        .environmentObject(store)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("選択中の日付")
                            .font(.headline)

                        Text(selectedDate.formatted(date: .long, time: .omitted))
                            .foregroundStyle(.secondary)

                        Divider()

                        Text("その日の予定")
                            .font(.headline)

                        let dayEvents = store.events(for: selectedDate)

                        if dayEvents.isEmpty {
                            Text("予定はありません")
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        } else {
                            ForEach(dayEvents) { event in
                                Button {
                                    selectedEvent = event
                                } label: {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(event.type.color)
                                            .frame(width: 10, height: 10)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(event.title)
                                                .foregroundStyle(.primary)
                                                .font(.headline)

                                            Text("\(event.companyName) ・ \(event.type.rawValue)")
                                                .foregroundStyle(.secondary)
                                                .font(.caption)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.tertiary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding()
                .padding(.top, 8)
            }
            .navigationTitle("カレンダー")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEventSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            .sheet(isPresented: $showingAddEventSheet) {
                AddEventView(defaultDate: selectedDate)
                    .environmentObject(store)
            }
        }
    }

    private func movePeriod(by value: Int) {
        let calendar = Calendar.current

        switch displayMode {
        case .month:
            currentDate = calendar.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
        case .week:
            currentDate = calendar.date(byAdding: .weekOfYear, value: value, to: currentDate) ?? currentDate
        }
    }

    private func titleText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }
}
