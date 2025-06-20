enum QuestType: Codable, Equatable {
    case walk
    case explore
    case walk_to
    case unknown(String)

    private static let _allCases: [QuestType] = [.walk, .explore, .walk_to]

    var rawValue: String {
        switch self {
        case .walk: return "walk"
        case .explore: return "explore"
        case .walk_to: return "walk_to"
        case .unknown(let value): return value
        }
    }

    init(rawValue: String) {
        switch rawValue {
        case "walk": self = .walk
        case "explore": self = .explore
        case "walk_to": self = .walk_to
        default: self = .unknown(rawValue)
        }
    }

    // Codable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = QuestType(rawValue: value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

struct Quest: Identifiable, Codable, Equatable {
    let id: Int
    let eventId: Int
    let type: QuestType
    let name: String
    let description: String
    let metric: String
    let xp: Int
    let points: [[Double]]?
    
    static func == (lhs: Quest, rhs: Quest) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let mock1 = Quest(
        id: 1,
        eventId: 1,
        type: .walk,
        name: "Nie masz psychy zrobić 10 000 kroków",
        description: "No balls, nie dasz rady, nee-eee",
        metric: "Kroki",
        xp: 50,
        points: []
    )

    static let mock2 = Quest(
        id: 2,
        eventId: 1,
        type: .walk_to,
        name: "Okryj czteropak",
        description: "Na zachodzie, potężna sala potężnych 4 hal od lego przez gierki i do mangi",
        metric: "Odkryj",
        xp: 30,
        points: [[52.4064, 16.9252]]
    )
}
