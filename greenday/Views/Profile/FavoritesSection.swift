import SwiftUI

struct FavoritesSection: View {

    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var recipeVM: RecipeViewModel

    private var favoriteRecipes: [Recipe] {
        challengeVM.favorites.compactMap { favorite in
            recipeVM.recipe(by: favorite.id)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("즐겨찾기 레시피")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(favoriteRecipes.count)개")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if favoriteRecipes.isEmpty {
                // 즐겨찾기 없을 때
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("아직 즐겨찾기한 레시피가 없어요")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("레시피 상세에서 하트를 탭해보세요")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
                .background(Color(.systemGray6))
                .cornerRadius(12)

            } else {
                VStack(spacing: 8) {
                    ForEach(favoriteRecipes) { recipe in
                        NavigationLink(destination:
                            RecipeDetailView(recipe: recipe)
                                .environmentObject(challengeVM)
                        ) {
                            FavoriteRowView(
                                recipe: recipe,
                                onRemove: {
                                    challengeVM.toggleFavorite(recipeId: recipe.id)
                                }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
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

// MARK: - 즐겨찾기 행
private struct FavoriteRowView: View {
    let recipe: Recipe
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(categoryEmoji(recipe.category))
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(Color(red: 0.75, green: 0.87, blue: 0.59))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 3) {
                Text(recipe.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("\(recipe.calories) kcal · \(recipe.category.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 즐겨찾기 해제 버튼
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(red: 0.83, green: 0.33, blue: 0.49))
                    .font(.body)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    private func categoryEmoji(_ category: Recipe.Category) -> String {
        switch category {
        case .korean:  return "🍱"
        case .western: return "🥗"
        case .snack:   return "🍪"
        }
    }
}
