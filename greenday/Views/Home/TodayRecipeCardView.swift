import SwiftUI

struct TodayRecipeCardView: View {

    let recipe: Recipe
    let isCompleted: Bool
    let onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘의 추천 레시피")
                .font(.subheadline).fontWeight(.semibold)

            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.75, green: 0.87, blue: 0.59))
                        .frame(width: 56, height: 56)
                    Text(categoryEmoji(recipe.category)).font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name).font(.body).fontWeight(.semibold)
                    Text("\(recipe.calories) kcal · CO₂ \(String(format: "%.1f", recipe.co2SavedKg))kg 절감")
                        .font(.caption).foregroundColor(.secondary)
                    HStack(spacing: 6) {
                        TagView(text: recipe.veganLevel.displayName, color: .green)
                        TagView(text: recipe.category.displayName, color: Color(red: 0.18, green: 0.55, blue: 0.55))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption).foregroundColor(.secondary)
            }

            Button(action: onComplete) {
                HStack {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    Text(isCompleted ? "오늘 완료했어요!" : "오늘 먹었어요")
                }
                .font(.subheadline).font(.subheadline.weight(.semibold))
                .foregroundColor(isCompleted ? .white : Color(red: 0.11, green: 0.62, blue: 0.46))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    isCompleted
                    ? Color(red: 0.11, green: 0.62, blue: 0.46)
                    : Color(red: 0.88, green: 0.97, blue: 0.93)
                )
                .cornerRadius(10)
                .animation(.easeInOut(duration: 0.2))
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

    private func categoryEmoji(_ category: Recipe.Category) -> String {
        switch category {
        case .korean:  return "🍱"
        case .western: return "🥗"
        case .snack:   return "🍪"
        }
    }
}
