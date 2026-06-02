import SwiftUI

struct CalendarView: View {

    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @EnvironmentObject private var recipeVM: RecipeViewModel
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // 월간 통계
                    HStack(spacing: 10) {
                        StatBox(value: "\(challengeVM.totalCompleted)일",
                                label: "완료",
                                color: Color(red: 0.11, green: 0.62, blue: 0.46))
                        StatBox(value: "\(Int(challengeVM.completionRate))%",
                                label: "달성률",
                                color: .primary)
                        StatBox(value: "\(challengeVM.streak)일",
                                label: "최장 스트릭",
                                color: .primary)
                    }

                    // 주간 달성률
                    VStack(alignment: .leading, spacing: 6) {
                        Text("이번 주 달성률")
                            .font(.caption).foregroundColor(.secondary)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemGray5)).frame(height: 28)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(red: 0.11, green: 0.62, blue: 0.46))
                                    .frame(
                                        width: geo.size.width * Double(challengeVM.weeklyCompleted) / 7.0,
                                        height: 28
                                    )
                                    .animation(.easeInOut(duration: 0.4))
                                Text("\(challengeVM.weeklyCompleted) / 7일")
                                    .font(.caption).fontWeight(.semibold)
                                    .foregroundColor(.white).padding(.leading, 10)
                            }
                        }
                        .frame(height: 28)
                    }

                    // 달력 그리드
                    CalendarGridView(
                        currentMonth: $currentMonth,
                        selectedDate: $selectedDate,
                        challengeVM: challengeVM
                    )

                    // 범례
                    HStack(spacing: 14) {
                        LegendItem(color: Color(red: 0.11, green: 0.62, blue: 0.46),
                                   label: "완료", borderColor: .clear)
                        LegendItem(color: Color(red: 0.98, green: 0.92, blue: 0.92),
                                   label: "미완료",
                                   borderColor: Color(red: 0.89, green: 0.29, blue: 0.29))
                        LegendItem(color: Color(red: 0.88, green: 0.97, blue: 0.93),
                                   label: "오늘",
                                   borderColor: Color(red: 0.11, green: 0.62, blue: 0.46))
                        Spacer()
                    }

                    // 선택된 날짜 레시피
                    SelectedDayRecipeView(
                        date: selectedDate,
                        challengeVM: challengeVM,
                        recipeVM: recipeVM
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("\(monthTitle(currentMonth)) 챌린지")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func monthTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "M월"
        return f.string(from: date)
    }
}

private struct StatBox: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title3).fontWeight(.bold).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct LegendItem: View {
    let color: Color
    let label: String
    let borderColor: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color)
                .overlay(Circle().stroke(borderColor, lineWidth: 1))
                .frame(width: 12, height: 12)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}
