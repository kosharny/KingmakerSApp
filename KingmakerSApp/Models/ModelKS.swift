import Foundation

struct ArticleKS: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let content: String
    let imageName: String
    let category: String
    var isFavorite: Bool
    var isRead: Bool
}

struct QuestKS: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let steps: [String]
    let imageName: String
    let category: String
    var isCompleted: Bool
    var currentStep: Int
    var isFavorite: Bool
}

struct UserStatsKS: Codable {
    var articlesReadCount: Int
    var questsCompletedCount: Int
    var activityScore: Int
    var coronationProgress: Double
    var hasCompletedOnboarding: Bool
    
    init() {
        self.articlesReadCount = 0
        self.questsCompletedCount = 0
        self.activityScore = 0
        self.coronationProgress = 0.0
        self.hasCompletedOnboarding = false
    }
}

struct WeaknessKS: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var improvementNotes: String
    var dateAdded: Date
    var isResolved: Bool
    var progress: Double // 0.0 to 1.0
}

enum ThemeKS: String, Codable, CaseIterable, Identifiable {
    case royalDefault = "Royal Default"
    case obsidianThrone = "Obsidian Throne"
    case crimsonEmpire = "Crimson Empire"
    
    var id: String { rawValue }
    
    var isPremium: Bool {
        self != .royalDefault
    }
    
    var price: String {
        isPremium ? "$1.99" : "Free"
    }
    
    var productID: String {
        switch self {
        case .royalDefault:
            return ""
        case .obsidianThrone:
            return "premium_theme_obsidian"
        case .crimsonEmpire:
            return "premium_theme_crimson"
        }
    }
}

struct JournalEntryKS: Identifiable, Codable {
    let id: String
    let title: String
    let type: EntryType
    let date: Date
    let itemID: String
    let imageName: String?
    
    enum EntryType: String, Codable {
        case articleRead = "Article Read"
        case questCompleted = "Quest Completed"
        case weaknessAdded = "Weakness Tracked"
        case weaknessResolved = "Weakness Resolved"
    }
}
