import Foundation

class ChallengeViewModel: ObservableObject {

    @Published private(set) var records: [String: ChallengeRecord] = [:]
    @Published private(set) var favorites: [FavoriteRecipe] = []

    var veganLevel: VeganLevel {
        get {
            let raw = UserDefaults.standard.integer(forKey: "veganLevel")
            return VeganLevel(rawValue: raw) ?? .flexitarian
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "veganLevel") }
    }

    var challengeDays: Int {
        get {
            let v = UserDefaults.standard.integer(forKey: "challengeDays")
            return v == 0 ? 30 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "challengeDays") }
    }

    var challengeStartDate: Date {
        get {
            UserDefaults.standard.object(forKey: "challengeStartDate") as? Date ?? Date()
        }
        set { UserDefaults.standard.set(newValue, forKey: "challengeStartDate") }
    }

    init() {
        records   = ChallengeRecord.loadAll()
        favorites = FavoriteRecipe.loadAll()
    }

    // MARK: - 챌린지 완료 토글
    func toggleComplete(on date: Date, recipe: Recipe) {
        let key = RecipeAssigner.dayKey(for: date)
        if var record = records[key] {
            record.isCompleted.toggle()
            record.co2Saved = record.isCompleted ? recipe.co2SavedKg : 0
            records[key] = record
        } else {
            records[key] = ChallengeRecord(
                date: date,
                recipeId: recipe.id,
                isCompleted: true,
                co2Saved: recipe.co2SavedKg
            )
        }
        ChallengeRecord.saveAll(records)
        objectWillChange.send()
    }

    func isCompleted(on date: Date) -> Bool {
        let key = RecipeAssigner.dayKey(for: date)
        return records[key]?.isCompleted ?? false
    }

    // MARK: - 즐겨찾기
    func toggleFavorite(recipeId: String) {
        if isFavorite(recipeId: recipeId) {
            favorites.removeAll { $0.id == recipeId }
        } else {
            favorites.append(FavoriteRecipe(recipeId: recipeId))
        }
        FavoriteRecipe.saveAll(favorites)
        objectWillChange.send()
    }

    func isFavorite(recipeId: String) -> Bool {
        favorites.contains { $0.id == recipeId }
    }

    // MARK: - 통계
    var streak: Int {
        var count = 0
        var date = Calendar.current.startOfDay(for: Date())
        while isCompleted(on: date) {
            count += 1
            guard let prev = Calendar.current.date(byAdding: .day, value: -1, to: date) else { break }
            date = prev
        }
        return count
    }

    var totalCompleted: Int {
        records.values.filter { $0.isCompleted }.count
    }

    var elapsedDays: Int {
        let days = Calendar.current.dateComponents([.day], from: challengeStartDate, to: Date()).day ?? 0
        return min(max(days, 0), challengeDays)
    }

    var completionRate: Double {
        guard elapsedDays > 0 else { return 0 }
        return Double(totalCompleted) / Double(elapsedDays) * 100
    }

    var totalCO2Saved: Double {
        records.values.filter { $0.isCompleted }.reduce(0) { $0 + $1.co2Saved }
    }

    var treesEquivalent: Double {
        totalCO2Saved / 54.0
    }

    var weeklyCompleted: Int {
        let calendar = Calendar.current
        let today = Date()
        let weekDates = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }
        return weekDates.filter { isCompleted(on: $0) }.count
    }
    func resetAll() {
        UserDefaults.standard.removeObject(forKey: "challengeRecords")
        UserDefaults.standard.removeObject(forKey: "challengeStartDate")
        UserDefaults.standard.removeObject(forKey: "challengeDays")
        records = [:]
        favorites = []
        challengeStartDate = Date()   
        objectWillChange.send()
    }
}
