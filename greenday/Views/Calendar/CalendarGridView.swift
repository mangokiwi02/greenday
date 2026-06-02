import SwiftUI

struct CalendarGridView: View {

    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    let challengeVM: ChallengeViewModel

    private let calendar = Calendar.current
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack(spacing: 10) {

            // 월 이동 헤더
            HStack {
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                }
                Spacer()
                Text(monthYearTitle(currentMonth))
                    .font(.subheadline).fontWeight(.semibold)
                Spacer()
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                }
            }
            .padding(.horizontal, 4)

            // 요일 헤더
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption2).fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // 날짜 그리드 — LazyVGrid 대신 VStack + HStack
            VStack(spacing: 6) {
                ForEach(weekRows(), id: \.self) { week in
                    HStack(spacing: 6) {
                        ForEach(0..<7, id: \.self) { index in
                            if let date = week[index] {
                                CalendarDayCell(
                                    date: date,
                                    isToday: calendar.isDateInToday(date),
                                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                    isCompleted: challengeVM.isCompleted(on: date),
                                    isMissed: isMissed(date),
                                    isFuture: date > Date()
                                )
                                .onTapGesture { selectedDate = date }
                            } else {
                                Color.clear.aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    // MARK: - 헬퍼

    private func monthYearTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy년 M월"
        return f.string(from: date)
    }

    // 날짜를 7개씩 주 단위로 묶어서 반환
    private func weekRows() -> [[Date?]] {
        let days = daysInMonth()
        var rows: [[Date?]] = []
        var week: [Date?] = []

        for day in days {
            week.append(day)
            if week.count == 7 {
                rows.append(week)
                week = []
            }
        }
        // 마지막 주 나머지 빈칸 채우기
        if !week.isEmpty {
            while week.count < 7 { week.append(nil) }
            rows.append(week)
        }
        return rows
    }

    private func daysInMonth() -> [Date?] {
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        return days
    }

    private func isMissed(_ date: Date) -> Bool {
        let isPast = date < calendar.startOfDay(for: Date())
        return isPast && !challengeVM.isCompleted(on: date)
    }
}
