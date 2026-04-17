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

            HStack(spacing: 4) {
                ForEach(Array(events.prefix(3).enumerated()), id: \.offset) { _, event in
                    Circle()
                        .fill(event.type.color)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .padding(.vertical, 6)
        .background(isSelected ? Color.blue.opacity(0.18) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}
