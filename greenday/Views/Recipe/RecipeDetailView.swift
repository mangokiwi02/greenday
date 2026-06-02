import SwiftUI

struct RecipeDetailView: View {

    let recipe: Recipe
    @EnvironmentObject private var challengeVM: ChallengeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // 상단 헤더 (이모지 + 배경)
                ZStack {
                    Color(red: 0.75, green: 0.87, blue: 0.59)
                        .frame(height: 160)
                    Text(categoryEmoji(recipe.category))
                        .font(.system(size: 72))
                }

                VStack(alignment: .leading, spacing: 16) {

                    // 이름 + 즐겨찾기
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(recipe.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            HStack(spacing: 6) {
                                TagView(text: recipe.veganLevel.displayName, color: .green)
                                TagView(text: recipe.category.displayName, color: Color(red: 0.18, green: 0.55, blue: 0.55))
                            }
                        }
                        Spacer()
                        Button(action: {
                            challengeVM.toggleFavorite(recipeId: recipe.id)
                        }) {
                            Image(systemName: challengeVM.isFavorite(recipeId: recipe.id)
                                  ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(
                                    challengeVM.isFavorite(recipeId: recipe.id)
                                    ? Color(red: 0.83, green: 0.33, blue: 0.49)
                                    : .secondary
                                )
                        }
                    }

                    // 영양 정보 4개
                    HStack(spacing: 8) {
                        NutritionBox(value: "\(recipe.calories)", unit: "kcal", label: "칼로리", color: Color(red: 0.11, green: 0.62, blue: 0.46))
                        NutritionBox(value: String(format: "%.0f", recipe.protein), unit: "g", label: "단백질", color: .primary)
                        NutritionBox(value: String(format: "%.0f", recipe.sugar), unit: "g", label: "당", color: .primary)
                        NutritionBox(value: String(format: "%.0f", recipe.fat), unit: "g", label: "지방", color: .primary)
                    }

                    // CO₂ 절감
                    HStack(spacing: 10) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                        Text("이 레시피로 CO₂ \(String(format: "%.1f", recipe.co2SavedKg))kg 절감")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.06, green: 0.43, blue: 0.33))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.88, green: 0.97, blue: 0.93))
                    .cornerRadius(10)

                    // 재료
                    VStack(alignment: .leading, spacing: 8) {
                        Text("재료")
                            .font(.headline)
                        FlowLayout(items: recipe.ingredients) { ingredient in
                            Text(ingredient)
                                .font(.subheadline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }

                    // 조리 순서
                    VStack(alignment: .leading, spacing: 10) {
                        Text("조리 순서")
                            .font(.headline)
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.11, green: 0.62, blue: 0.46))
                                        .frame(width: 24, height: 24)
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                Text(step)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    // 오늘 먹었어요 버튼
                    Button(action: {
                        challengeVM.toggleComplete(on: Date(), recipe: recipe)
                    }) {
                        HStack {
                            Image(systemName: challengeVM.isCompleted(on: Date())
                                  ? "checkmark.circle.fill" : "circle")
                            Text(challengeVM.isCompleted(on: Date())
                                 ? "오늘 완료했어요!" : "오늘 먹었어요")
                        }
                        .font(.body)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(
                            challengeVM.isCompleted(on: Date()) ? .white
                            : Color(red: 0.11, green: 0.62, blue: 0.46)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            challengeVM.isCompleted(on: Date())
                            ? Color(red: 0.11, green: 0.62, blue: 0.46)
                            : Color(red: 0.88, green: 0.97, blue: 0.93)
                        )
                        .cornerRadius(12)
                        .animation(.easeInOut(duration: 0.2))
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }

    private func categoryEmoji(_ category: Recipe.Category) -> String {
        switch category {
        case .korean:  return "🍱"
        case .western: return "🥗"
        case .snack:   return "🍪"
        }
    }
}

// MARK: - 영양 정보 박스
private struct NutritionBox: View {
    let value: String
    let unit: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(color.opacity(0.8))
            }
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - 재료 태그 흘러넘치는 레이아웃
private struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    @State private var totalHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        var rows: [[Item]] = [[]]

        for item in items {
            let itemWidth: CGFloat = 100
            if width + itemWidth > geo.size.width {
                rows.append([item])
                width = itemWidth + 8
                height += 36
            } else {
                rows[rows.count - 1].append(item)
                width += itemWidth + 8
            }
        }

        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
        .background(GeometryReader { geo in
            Color.clear.onAppear {
                totalHeight = geo.size.height
            }
        })
    }
}
