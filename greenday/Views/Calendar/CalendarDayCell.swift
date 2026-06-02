import SwiftUI

struct CalendarDayCell: View {

    let date: Date
    let isToday: Bool
    let isSelected: Bool
    let isCompleted: Bool
    let isMissed: Bool
    let isFuture: Bool

    private var day: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
    }

    private var backgroundColor: Color {
        if isCompleted { return Color(red: 0.11, green: 0.62, blue: 0.46) }
        if isMissed    { return Color(red: 0.98, green: 0.92, blue: 0.92) }
        if isToday     { return Color(red: 0.88, green: 0.97, blue: 0.93) }
        return Color.clear
    }

    private var textColor: Color {
        if isCompleted { return .white }
        if isMissed    { return Color(red: 0.75, green: 0.18, blue: 0.18) }
        if isToday     { return Color(red: 0.06, green: 0.43, blue: 0.33) }
        if isFuture    { return Color(.systemGray3) }
        return .primary
    }

    private var borderColor: Color {
        if isSelected && !isCompleted { return Color(red: 0.11, green: 0.62, blue: 0.46) }
        if isMissed { return Color(red: 0.89, green: 0.29, blue: 0.29) }
        if isToday && !isCompleted { return Color(red: 0.11, green: 0.62, blue: 0.46) }
        return Color.clear
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .overlay(Circle().stroke(borderColor, lineWidth: 1.2))
            Text(day)
                .font(.caption2)
                .fontWeight(isToday || isCompleted ? .semibold : .regular)
                .foregroundColor(textColor)
        }
        .aspectRatio(1, contentMode: .fit)
        .animation(.easeInOut(duration: 0.15))
    }
}
