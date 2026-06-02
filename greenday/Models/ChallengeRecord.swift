import Foundation

struct ChallengeRecord: Codable, Identifiable {
    var id: String { dayKey }
    let dayKey: String
    let recipeId: String
    var isCompleted: Bool
    var co2Saved: Double

    init(date: Date, recipeId: String, isCompleted: Bool = false, co2Saved: Double = 0) {
        self.dayKey      = ChallengeRecord.formatDate(date)
        self.recipeId    = recipeId
        self.isCompleted = isCompleted
        self.co2Saved    = co2Saved
    }

    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension ChallengeRecord {
    private static let storageKey = "challengeRecords"

    static func loadAll() -> [String: ChallengeRecord] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let records = try? JSONDecoder().decode([String: ChallengeRecord].self, from: data)
        else { return [:] }
        return records
    }

    static func saveAll(_ records: [String: ChallengeRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
