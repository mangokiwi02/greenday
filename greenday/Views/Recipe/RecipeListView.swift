import SwiftUI

struct RecipeListView: View {

    @EnvironmentObject private var recipeVM: RecipeViewModel
    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @State private var selectedCategory: Recipe.Category? = nil
    @State private var searchText = ""

    private var filteredRecipes: [Recipe] {
        let byCategory: [Recipe]
        if let category = selectedCategory {
            byCategory = recipeVM.allRecipes.filter { $0.category == category }
        } else {
            byCategory = recipeVM.allRecipes
        }

        if searchText.isEmpty {
            return byCategory
        } else {
            return byCategory.filter { $0.name.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // 검색창
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("레시피 검색", text: $searchText)
                        .font(.subheadline)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                // 카테고리 필터 칩
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "전체", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(Recipe.Category.allCases, id: \.self) { category in
                            FilterChip(title: category.displayName, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 8)

                // 레시피 목록
                if filteredRecipes.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("레시피가 없어요")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(destination:
                                    RecipeDetailView(recipe: recipe)
                                        .environmentObject(challengeVM)
                                ) {
                                    RecipeRowView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("레시피")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - 필터 칩
private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    isSelected
                    ? Color(red: 0.11, green: 0.62, blue: 0.46)
                    : Color(.systemGray6)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: - 레시피 행
private struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            // 이모지 썸네일
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.75, green: 0.87, blue: 0.59))
                    .frame(width: 52, height: 52)
                Text(categoryEmoji(recipe.category))
                    .font(.title2)
            }

            // 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("\(recipe.calories) kcal · 단백질 \(String(format: "%.0f", recipe.protein))g")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 6) {
                    TagView(text: recipe.veganLevel.displayName, color: .green)
                    TagView(text: recipe.category.displayName, color: Color(red: 0.18, green: 0.55, blue: 0.55))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
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
