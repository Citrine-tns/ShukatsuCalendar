import SwiftUI

enum EventEditorMode {
    case create(prefilledDate: Date?, prefilledCategory: EventCategory?)
    case edit(CalendarEvent)
}

struct EventEditorSheet: View {
    let mode: EventEditorMode
    let onSave: (CalendarEvent) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var category: EventCategory = .other
    @State private var isAllDay: Bool = false
    @State private var startAt: Date = Date()
    @State private var endAt: Date = Date()
    @State private var hasEndAt: Bool = false
    @State private var company: String = ""
    @State private var urlString: String = ""
    @State private var eventDescription: String = ""

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var navigationTitle: String {
        isEditing ? "予定を編集" : "予定を追加"
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("タイトル", text: $title)
                    Picker("カテゴリ", selection: $category) {
                        ForEach(EventCategory.allCases) { c in
                            Text(c.displayName).tag(c)
                        }
                    }
                }

                Section {
                    Toggle("終日", isOn: $isAllDay)
                    DatePicker(
                        "開始",
                        selection: $startAt,
                        displayedComponents: isAllDay ? [.date] : [.date, .hourAndMinute]
                    )
                    if !isAllDay {
                        Toggle("終了時刻あり", isOn: $hasEndAt)
                        if hasEndAt {
                            DatePicker(
                                "終了",
                                selection: $endAt,
                                in: startAt...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                    }
                }

                Section("詳細(任意)") {
                    TextField("会社・組織名", text: $company)
                    TextField("URL", text: $urlString)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("メモ", text: $eventDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        save()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear { loadInitialValues() }
        }
    }

    private func loadInitialValues() {
        switch mode {
        case .create(let prefilledDate, let prefilledCategory):
            let baseDate = prefilledDate ?? Date()
            startAt = baseDate
            endAt = Calendar.current.date(byAdding: .hour, value: 1, to: baseDate) ?? baseDate
            if let prefilledCategory {
                category = prefilledCategory
                if prefilledCategory == .internshipDeadline {
                    isAllDay = true
                }
            }
        case .edit(let event):
            title = event.title
            category = event.category
            isAllDay = event.isAllDay
            startAt = event.startAt
            if let end = event.endAt {
                endAt = end
                hasEndAt = true
            } else {
                endAt = Calendar.current.date(byAdding: .hour, value: 1, to: event.startAt) ?? event.startAt
                hasEndAt = false
            }
            company = event.company ?? ""
            urlString = event.url?.absoluteString ?? ""
            eventDescription = event.eventDescription ?? ""
        }
    }

    private func save() {
        let trimmedCompany = company.trimmingCharacters(in: .whitespaces)
        let trimmedURL = urlString.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = eventDescription.trimmingCharacters(in: .whitespaces)

        let resolvedURL: URL? = trimmedURL.isEmpty ? nil : URL(string: trimmedURL)
        let resolvedEnd: Date? = (!isAllDay && hasEndAt) ? endAt : nil

        switch mode {
        case .create:
            let new = CalendarEvent(
                title: title.trimmingCharacters(in: .whitespaces),
                category: category,
                startAt: startAt,
                endAt: resolvedEnd,
                isAllDay: isAllDay,
                company: trimmedCompany.isEmpty ? nil : trimmedCompany,
                eventDescription: trimmedDescription.isEmpty ? nil : trimmedDescription,
                url: resolvedURL,
                source: .manual
            )
            onSave(new)
        case .edit(let original):
            var updated = original
            updated.title = title.trimmingCharacters(in: .whitespaces)
            updated.category = category
            updated.startAt = startAt
            updated.endAt = resolvedEnd
            updated.isAllDay = isAllDay
            updated.company = trimmedCompany.isEmpty ? nil : trimmedCompany
            updated.eventDescription = trimmedDescription.isEmpty ? nil : trimmedDescription
            updated.url = resolvedURL
            onSave(updated)
        }
    }
}
