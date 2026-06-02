import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @EnvironmentObject private var recipeVM: RecipeViewModel
    @AppStorage("veganLevel") private var veganLevelRaw = 0
    @AppStorage("isOnboardingDone") private var isOnboardingDone = false
    @State private var showLevelPicker = false
    @State private var showResetAlert = false

    private var veganLevel: VeganLevel {
        VeganLevel(rawValue: veganLevelRaw) ?? .flexitarian
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // 프로필 헤더
                    ProfileHeaderView(veganLevel: veganLevel)

                    // 통계 카드
                    StatsCardView(challengeVM: challengeVM)

                    // 즐겨찾기 섹션
                    FavoritesSection(
                        challengeVM: challengeVM,
                        recipeVM: recipeVM
                    )

                    // 설정 섹션
                    SettingsSection(
                        showLevelPicker: $showLevelPicker,
                        showResetAlert: $showResetAlert
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("프로필")
            .sheet(isPresented: $showLevelPicker) {
                VeganLevelPickerView()
                    .environmentObject(challengeVM)
            }
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("챌린지 재시작"),
                    message: Text("모든 기록이 초기화돼요. 정말 재시작할까요?"),
                    primaryButton: .destructive(Text("재시작")) {
                        resetChallenge()
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func resetChallenge() {
        challengeVM.resetAll()    // ← ViewModel 함수 하나로 해결
        isOnboardingDone = false
    }
}

// MARK: - 프로필 헤더
private struct ProfileHeaderView: View {
    let veganLevel: VeganLevel

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.88, green: 0.97, blue: 0.93))
                    .frame(width: 60, height: 60)
                Text(veganLevel.emoji)
                    .font(.title)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("나의 비건 챌린지")
                    .font(.title3)
                    .fontWeight(.bold)
                TagView(
                    text: veganLevel.displayName,
                    color: Color(red: 0.11, green: 0.62, blue: 0.46)
                )
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

// MARK: - 통계 카드
private struct StatsCardView: View {
    @ObservedObject var challengeVM: ChallengeViewModel

    var body: some View {
        VStack(spacing: 12) {
            // 상단 3개
            HStack(spacing: 8) {
                StatItem(
                    value: "\(challengeVM.streak)일",
                    label: "연속 달성",
                    color: Color(red: 0.11, green: 0.62, blue: 0.46)
                )
                StatItem(
                    value: "\(challengeVM.totalCompleted)일",
                    label: "총 완료",
                    color: .primary
                )
                StatItem(
                    value: "\(Int(challengeVM.completionRate))%",
                    label: "달성률",
                    color: .primary
                )
            }

            // 하단 CO₂
            HStack(spacing: 8) {
                StatItem(
                    value: String(format: "%.1fkg", challengeVM.totalCO2Saved),
                    label: "CO₂ 절감",
                    color: Color(red: 0.15, green: 0.44, blue: 0.07)
                )
                StatItem(
                    value: String(format: "%.2f그루", challengeVM.treesEquivalent),
                    label: "나무 심은 효과",
                    color: Color(red: 0.03, green: 0.31, blue: 0.25)
                )
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

private struct StatItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - 설정 섹션
private struct SettingsSection: View {
    @Binding var showLevelPicker: Bool
    @Binding var showResetAlert: Bool

    var body: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "leaf.fill",
                iconColor: Color(red: 0.11, green: 0.62, blue: 0.46),
                title: "비건 단계 변경"
            ) {
                showLevelPicker = true
            }

            Divider().padding(.leading, 44)

            SettingsRow(
                icon: "arrow.counterclockwise",
                iconColor: .orange,
                title: "챌린지 재시작"
            ) {
                showResetAlert = true
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

private struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundColor(iconColor)
                }
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}
