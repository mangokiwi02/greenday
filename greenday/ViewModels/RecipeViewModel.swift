import Foundation

class RecipeViewModel: ObservableObject {

    @Published private(set) var allRecipes: [Recipe] = []
    @Published private(set) var filteredRecipes: [Recipe] = []

    var selectedCategory: Recipe.Category? = nil {
        didSet { applyFilter() }
    }

    var veganLevel: VeganLevel {
        let raw = UserDefaults.standard.integer(forKey: "veganLevel")
        return VeganLevel(rawValue: raw) ?? .flexitarian
    }

    init() {
        allRecipes = Recipe.loadAll()
        applyFilter()
    }

    func todayRecipe() -> Recipe? {
        RecipeAssigner.recipe(for: Date(), veganLevel: veganLevel, from: allRecipes)
    }

    func recipe(for date: Date) -> Recipe? {
        RecipeAssigner.recipe(for: date, veganLevel: veganLevel, from: allRecipes)
    }

    func recipe(by id: String) -> Recipe? {
        allRecipes.first { $0.id == id }
    }

    private func applyFilter() {
        let levelFiltered = allRecipes.filter { $0.veganLevel.rawValue >= veganLevel.rawValue }
        if let category = selectedCategory {
            filteredRecipes = levelFiltered.filter { $0.category == category }
        } else {
            filteredRecipes = levelFiltered
        }
    }
}
