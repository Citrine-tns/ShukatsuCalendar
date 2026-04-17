import SwiftUI

struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let events: [JobEvent]

    var body: some View {
        VStack(spacing: 6) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.body)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(.primary)

            if events.isEmpty {
                Spacer()
                    .frame(height: 8)
            } else {
                VStack(spacing: 2) {
                    ForEach(Array(events.prefix(2).enumerated()), id: \.offset) { _, event in
                        Text(event.title)
                            .font(.caption2)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(event.type.color.opacity(0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }

                    if events.count > 2 {
                        Text("他 \(events.count - 2) 件")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .top)
        .padding(6)
        .background(isSelected ? Color.blue.opacity(0.18) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}
