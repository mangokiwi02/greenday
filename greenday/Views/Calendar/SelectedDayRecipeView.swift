import SwiftUI

struct SelectedDayRecipeView: View {

    let date: Date
    let challengeVM: ChallengeViewModel
    let recipeVM: RecipeViewModel

    private var isToday: Bool { Calendar.current.isDateInToday(date) }
    private var isFuture: Bool {
        date > Calendar.current.startOfDay(for: Date()) && !Calendar.current.isDateInToday(date)
    }
    private var isMissed: Bool {
        date < Calendar.current.startOfDay(for: Date()) && !challengeVM.isCompleted(on: date)
    }
    private var recipe: Recipe? { recipeVM.recipe(for: date) }

    private var dateTitle: String {
        let f = DateFormatter()
        f.dateFormat = "M월 d일"
        return (isToday ? "오늘 · " : "") + f.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(dateTitle).font(.subheadline).fontWeight(.semibold)

            if isFuture {
                HStack {
                    Image(systemName: "clock").foregroundColor(.secondary)
                    Text("아직 오지 않은 날이에요")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color(.systemGray6))
                .cornerRadius(12)

            } else if let recipe = recipe {
                HStack(spacing: 12) {
                    Text(categoryEmoji(recipe.category))
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(Color(red: 0.75, green: 0.87, blue: 0.59))
                        .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(recipe.name).font(.subheadline).fontWeight(.semibold)
                        Text("\(recipe.calories)kcal · CO₂ \(String(format: "%.1f", recipe.co2SavedKg))kg 절감")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    if challengeVM.isCompleted(on: date) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                            .font(.title3)
                    } else if isMissed {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(red: 0.89, green: 0.29, blue: 0.29))
                            .font(.title3)
                    }
                }
                .padding(12)
                .background(isMissed ? Color(red: 0.98, green: 0.92, blue: 0.92) : Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isMissed
                            ? Color(red: 0.89, green: 0.29, blue: 0.29).opacity(0.4)
                            : Color(.systemGray5),
                            lineWidth: 0.5
                        )
                )

                if isToday {
                    Button(action: {
                        challengeVM.toggleComplete(on: date, recipe: recipe)
                    }) {
                        HStack {
                            Image(systemName: challengeVM.isCompleted(on: date)
                                  ? "checkmark.circle.fill" : "circle")
                            Text(challengeVM.isCompleted(on: date)
                                 ? "오늘 완료했어요!" : "오늘 먹었어요")
                        }
                        .font(.subheadline).font(.subheadline.weight(.semibold))
                        .foregroundColor(
                            challengeVM.isCompleted(on: date) ? .white
                            : Color(red: 0.11, green: 0.62, blue: 0.46)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            challengeVM.isCompleted(on: date)
                            ? Color(red: 0.11, green: 0.62, blue: 0.46)
                            : Color(red: 0.88, green: 0.97, blue: 0.93)
                        )
                        .cornerRadius(10)
                        .animation(.easeInOut(duration: 0.2))
                    }
                }

                if isMissed {
                    Text("이날 챌린지를 놓쳤어요 😢")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.75, green: 0.18, blue: 0.18))
                }
            }
        }
    }

    private func categoryEmoji(_ category: Recipe.Category) -> String {
        switch category {
        case .korean:  return "🍱"
        case .western: return "🥗"
        case .snack:   return "🍪"
        }
    }
}
