import Foundation

struct RecipeAssigner {

    static func recipe(for date: Date, veganLevel: VeganLevel, from recipes: [Recipe]) -> Recipe? {
        let filtered = recipes.filter { $0.veganLevel.rawValue >= veganLevel.rawValue }
        guard !filtered.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return filtered[dayOfYear % filtered.count]
    }

    static func dayKey(for date: Date) -> String {
        ChallengeRecord.formatDate(date)
    }
}
