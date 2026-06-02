import Foundation

struct Recipe: Codable, Identifiable {
    let id: String
    let name: String
    let veganLevel: VeganLevel
    let category: Category
    let calories: Int
    let protein: Double
    let fat: Double
    let sugar: Double
    let co2SavedKg: Double
    let ingredients: [String]
    let steps: [String]

    enum Category: String, Codable, CaseIterable {
        case korean  = "한식"
        case western = "양식"
        case snack   = "간식"

        var displayName: String { rawValue }
    }

    static func loadAll() -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let recipes = try? JSONDecoder().decode([Recipe].self, from: data)
        else {
            print("❌ recipes.json 로딩 실패")
            return []
        }
        print("✅ 레시피 로딩 성공: \(recipes.count)개")
        return recipes
    }
}
