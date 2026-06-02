import SwiftUI

struct ChallengePeriodView: View {

    @AppStorage("isOnboardingDone") private var isOnboardingDone = false
    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @State private var selected = 30

    private let options: [(days: Int, label: String, sublabel: String)] = [
        (7,  "7일",  "입문"),
        (30, "30일", "추천"),
        (60, "60일", "심화"),
        (90, "90일", "마스터")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ProgressDotsView(current: 1, total: 2)
                .padding(.top, 60)
                .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 8) {
                Text("챌린지 기간을 설정하세요")
                    .font(.title2).fontWeight(.bold)
                Text("선택한 기간 동안 매일 레시피 챌린지가 진행돼요.")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.bottom, 32)

            // LazyVGrid 대신 HStack 2개로 2열 구현
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    PeriodCard(days: options[0].days, label: options[0].label,
                               sublabel: options[0].sublabel, isSelected: selected == options[0].days)
                        .onTapGesture { selected = options[0].days }
                    PeriodCard(days: options[1].days, label: options[1].label,
                               sublabel: options[1].sublabel, isSelected: selected == options[1].days)
                        .onTapGesture { selected = options[1].days }
                }
                HStack(spacing: 12) {
                    PeriodCard(days: options[2].days, label: options[2].label,
                               sublabel: options[2].sublabel, isSelected: selected == options[2].days)
                        .onTapGesture { selected = options[2].days }
                    PeriodCard(days: options[3].days, label: options[3].label,
                               sublabel: options[3].sublabel, isSelected: selected == options[3].days)
                        .onTapGesture { selected = options[3].days }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                challengeVM.challengeDays = selected
                challengeVM.challengeStartDate = Date()
                isOnboardingDone = true
            }) {
                Text("시작하기")
                    .font(.body).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.85))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

private struct PeriodCard: View {
    let days: Int
    let label: String
    let sublabel: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.title2).fontWeight(.bold)
                .foregroundColor(isSelected ? Color(red: 0.06, green: 0.43, blue: 0.33) : .primary)
            Text(sublabel)
                .font(.caption)
                .foregroundColor(isSelected ? Color(red: 0.12, green: 0.55, blue: 0.42) : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(isSelected ? Color(red: 0.88, green: 0.97, blue: 0.93) : Color(.systemGray6))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color(red: 0.11, green: 0.62, blue: 0.46) : Color.clear, lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.15))
    }
}
