import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @EnvironmentObject private var recipeVM: RecipeViewModel
    @AppStorage("veganLevel") private var veganLevelRaw = 0

    private var veganLevel: VeganLevel {
        VeganLevel(rawValue: veganLevelRaw) ?? .flexitarian
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    HeaderView(veganLevel: veganLevel, day: challengeVM.elapsedDays)

                    StreakCardView(
                        streak: challengeVM.streak,
                        elapsedDays: challengeVM.elapsedDays,
                        challengeDays: challengeVM.challengeDays,
                        completionRate: challengeVM.completionRate
                    )

                    CO2CardView(
                        totalCO2: challengeVM.totalCO2Saved,
                        treesEquivalent: challengeVM.treesEquivalent
                    )

                    if let recipe = recipeVM.todayRecipe() {
                        TodayRecipeCardView(
                            recipe: recipe,
                            isCompleted: challengeVM.isCompleted(on: Date()),
                            onComplete: {
                                challengeVM.toggleComplete(on: Date(), recipe: recipe)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("GreenDay")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct HeaderView: View {
    let veganLevel: VeganLevel
    let day: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("안녕하세요 👋")
                    .font(.title3).fontWeight(.bold)
                Text("Day \(day) · \(veganLevel.displayName)")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(red: 0.88, green: 0.97, blue: 0.93))
                    .frame(width: 40, height: 40)
                Image(systemName: "person.fill")
                    .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
            }
        }
    }
}
