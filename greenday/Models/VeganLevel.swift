import Foundation

enum VeganLevel: Int, Codable, CaseIterable {
    case flexitarian = 0
    case vegetarian  = 1
    case vegan       = 2

    var displayName: String {
        switch self {
        case .flexitarian: return "플렉시테리언"
        case .vegetarian:  return "베지테리언"
        case .vegan:       return "비건"
        }
    }

    var description: String {
        switch self {
        case .flexitarian: return "가끔 육류 섭취 허용"
        case .vegetarian:  return "유제품·달걀 허용"
        case .vegan:       return "동물성 식품 완전 배제"
        }
    }

    var emoji: String {
        switch self {
        case .flexitarian: return "🌿"
        case .vegetarian:  return "🥚"
        case .vegan:       return "🌱"
        }
    }
}
