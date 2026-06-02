import Foundation

struct FavoriteRecipe: Codable, Identifiable {
    let id: String
    let savedAt: Date

    init(recipeId: String) {
        self.id      = recipeId
        self.savedAt = Date()
    }
}

extension FavoriteRecipe {
    private static let storageKey = "favoriteRecipes"

    static func loadAll() -> [FavoriteRecipe] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let favorites = try? JSONDecoder().decode([FavoriteRecipe].self, from: data)
        else { return [] }
        return favorites
    }

    static func saveAll(_ favorites: [FavoriteRecipe]) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
