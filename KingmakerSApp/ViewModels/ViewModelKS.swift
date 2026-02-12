import Foundation
import SwiftUI
import Combine

class ViewModelKS: ObservableObject {
    @Published var articles: [ArticleKS] = []
    @Published var quests: [QuestKS] = []
    @Published var weaknesses: [WeaknessKS] = []
    @Published var journalEntries: [JournalEntryKS] = []
    @Published var userStats: UserStatsKS = UserStatsKS()
    @Published var selectedTheme: ThemeKS = .royalDefault
    @Published var purchasedThemes: Set<String> = []
    @Published var searchText: String = ""
    @Published var showSplash: Bool = true
    @Published var showOnboarding: Bool = false
    @Published var isTabBarHidden: Bool = false
    
    private let userDefaultsKey = "KingmakerS_UserData"
    private let statsKey = "KingmakerS_Stats"
    private let themeKey = "KingmakerS_Theme"
    private let purchasedKey = "KingmakerS_Purchased"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadArticles()
        loadQuests()
        loadUserData()
        loadStats()
        loadTheme()
        loadPurchases()
        
        setupStoreSubscription()
    }
    
    private func setupStoreSubscription() {
        StoreManagerKS.shared.$purchasedProductIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] purchasedIDs in
                guard let self = self else { return }
                
                // If the store hasn't loaded yet and we have local data, trust local data for now.
                // But we should always update our local cache if the store *has* loaded or has data.
                if StoreManagerKS.shared.isLoaded || !purchasedIDs.isEmpty {
                     self.purchasedThemes = purchasedIDs
                     self.savePurchases()
                }
                
                // Only reset if we are sure we don't have access.
                if self.selectedTheme.isPremium {
                    // If store is loaded, rely on it
                    if StoreManagerKS.shared.isLoaded {
                        if !self.purchasedThemes.contains(self.selectedTheme.productID) {
                            self.selectedTheme = .royalDefault
                            self.saveTheme()
                        }
                    } else {
                        // Store not loaded yet.
                        // Rely on our locally loaded purchasedThemes (from init).
                        // If our local cache says we don't have it, AND we are premium, reset?
                        // Actually, if local cache is empty, we might have lost it or never had it.
                        // But to be safe against race conditions, we should probably wait for store load
                        // before *removing* access, unless we are sure.
                        // However, if we just launched, loadPurchases() already ran.
                        // So self.purchasedThemes contains what we last saved.
                        // If that doesn't contain the theme, and it's premium, we should arguably reset.
                        // But if purchasedThemes DOES contain it, we are good.
                        if !self.purchasedThemes.contains(self.selectedTheme.productID) && self.purchasedThemes.isEmpty {
                            // If we have NO local record, and store isn't loaded, maybe we should wait?
                            // But usually if a user has access, local record exists.
                            // Let's safe-guard: Do NOT reset until store is loaded.
                        } else if !self.purchasedThemes.contains(self.selectedTheme.productID) {
                             // We have some purchases, but not this one. Reset.
                             self.selectedTheme = .royalDefault
                             self.saveTheme()
                        }
                    }
                }
            }
            .store(in: &cancellables)
            
        // Also subscribe to isLoaded to trigger a re-check when it becomes true
        StoreManagerKS.shared.$isLoaded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoaded in
                guard let self = self, isLoaded else { return }
                // Re-sync when loaded
                self.purchasedThemes = StoreManagerKS.shared.purchasedProductIDs
                self.savePurchases()
                
                if self.selectedTheme.isPremium && !self.purchasedThemes.contains(self.selectedTheme.productID) {
                    self.selectedTheme = .royalDefault
                    self.saveTheme()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadArticles() {
        guard let url = Bundle.main.url(forResource: "ArticlesKS", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([ArticleKS].self, from: data) else {
            articles = []
            return
        }
        articles = decoded
    }
    
    private func loadQuests() {
        guard let url = Bundle.main.url(forResource: "QuestsKS", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([QuestKS].self, from: data) else {
            quests = []
            return
        }
        quests = decoded
    }
    
    private func loadUserData() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
            self.weaknesses = decoded.weaknesses
            self.journalEntries = decoded.journalEntries
            
            for i in 0..<articles.count {
                if let savedArticle = decoded.articles.first(where: { $0.id == articles[i].id }) {
                    articles[i].isFavorite = savedArticle.isFavorite
                    articles[i].isRead = savedArticle.isRead
                }
            }
            
            for i in 0..<quests.count {
                if let savedQuest = decoded.quests.first(where: { $0.id == quests[i].id }) {
                    quests[i].isCompleted = savedQuest.isCompleted
                    quests[i].currentStep = savedQuest.currentStep
                    quests[i].isFavorite = savedQuest.isFavorite
                }
            }
        } else {
            // First launch or no data found
            seedDefaultWeaknesses()
        }
        
        if self.weaknesses.isEmpty {
             seedDefaultWeaknesses()
        }
    }
    
    private func loadStats() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(UserStatsKS.self, from: data) {
            self.userStats = decoded
            self.showOnboarding = !decoded.hasCompletedOnboarding
        } else {
            self.showOnboarding = true
        }
    }
    
    private func loadTheme() {
        if let themeRaw = UserDefaults.standard.string(forKey: themeKey),
           let theme = ThemeKS(rawValue: themeRaw) {
            self.selectedTheme = theme
        }
    }
    
    private func loadPurchases() {
        if let data = UserDefaults.standard.data(forKey: purchasedKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.purchasedThemes = decoded
        }
    }
    
    func saveUserData() {
        let userData = UserData(
            articles: articles,
            quests: quests,
            weaknesses: weaknesses,
            journalEntries: journalEntries
        )
        if let encoded = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func saveStats() {
        if let encoded = try? JSONEncoder().encode(userStats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    func saveTheme() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
    }
    
    func savePurchases() {
        if let encoded = try? JSONEncoder().encode(purchasedThemes) {
            UserDefaults.standard.set(encoded, forKey: purchasedKey)
        }
    }
    
    func markArticleAsRead(_ articleID: String) {
        if let index = articles.firstIndex(where: { $0.id == articleID }) {
            if !articles[index].isRead {
                articles[index].isRead = true
                userStats.articlesReadCount += 1
                userStats.activityScore += 10
                updateCoronationProgress()
                addJournalEntry(title: articles[index].title, type: .articleRead, itemID: articleID, imageName: articles[index].imageName)
                saveUserData()
                saveStats()
            }
        }
    }
    
    func toggleArticleFavorite(_ articleID: String) {
        if let index = articles.firstIndex(where: { $0.id == articleID }) {
            articles[index].isFavorite.toggle()
            saveUserData()
        }
    }
    
    func toggleQuestFavorite(_ questID: String) {
        if let index = quests.firstIndex(where: { $0.id == questID }) {
            quests[index].isFavorite.toggle()
            saveUserData()
        }
    }
    
    func completeQuest(_ questID: String) {
        if let index = quests.firstIndex(where: { $0.id == questID }) {
            if !quests[index].isCompleted {
                quests[index].isCompleted = true
                userStats.questsCompletedCount += 1
                userStats.activityScore += 50
                updateCoronationProgress()
                addJournalEntry(title: quests[index].title, type: .questCompleted, itemID: questID, imageName: quests[index].imageName)
                saveUserData()
                saveStats()
            }
        }
    }
    
    // MARK: - Weakness Logic
    
    func seedDefaultWeaknesses() {
        let defaults = [
            ("Impatience", "The desire for immediate results often leads to poor long-term decisions."),
            ("Fear of Failure", "Paralysis in the face of risk prevents necessary action."),
            ("Pride", "Arrogance blinds one to their own faults and the wisdom of others.")
        ]
        
        for (title, desc) in defaults {
             addWeakness(title: title, description: desc)
        }
    }
    
    func updateQuestStep(_ questID: String, step: Int) {
        if let index = quests.firstIndex(where: { $0.id == questID }) {
            quests[index].currentStep = step
            saveUserData()
        }
    }
    

    
    func addWeakness(title: String, description: String) {
        let weakness = WeaknessKS(
            id: UUID().uuidString,
            title: title,
            description: description,
            improvementNotes: "",
            dateAdded: Date(),
            isResolved: false,
            progress: 0.0
        )
        weaknesses.append(weakness)
        addJournalEntry(title: title, type: .weaknessAdded, itemID: weakness.id, imageName: "shield.slash.fill")
        saveUserData()
    }
    
    func developWeakness(_ weaknessID: String) {
        if let index = weaknesses.firstIndex(where: { $0.id == weaknessID }) {
            weaknesses[index].progress = min(weaknesses[index].progress + 0.1, 1.0)
            saveUserData()
        }
    }
    
    func resolveWeakness(_ weaknessID: String) {
        if let index = weaknesses.firstIndex(where: { $0.id == weaknessID }) {
            weaknesses[index].isResolved = true
            weaknesses[index].progress = 1.0 // Ensure it's 100%
            userStats.activityScore += 30
            updateCoronationProgress()
            addJournalEntry(title: weaknesses[index].title, type: .weaknessResolved, itemID: weaknessID, imageName: "shield.fill")
            saveUserData()
            saveStats()
        }
    }
    
    func updateWeakness(_ weaknessID: String, notes: String) {
        if let index = weaknesses.firstIndex(where: { $0.id == weaknessID }) {
            weaknesses[index].improvementNotes = notes
            saveUserData()
        }
    }
    
    private func addJournalEntry(title: String, type: JournalEntryKS.EntryType, itemID: String, imageName: String? = nil) {
        let entry = JournalEntryKS(
            id: UUID().uuidString,
            title: title,
            type: type,
            date: Date(),
            itemID: itemID,
            imageName: imageName
        )
        journalEntries.insert(entry, at: 0)
    }
    
    private func updateCoronationProgress() {
        let totalPossible = Double(articles.count + quests.count + 10)
        let completed = Double(userStats.articlesReadCount + userStats.questsCompletedCount + weaknesses.filter { $0.isResolved }.count)
        userStats.coronationProgress = min(completed / totalPossible, 1.0)
    }
    
    func completeOnboarding() {
        userStats.hasCompletedOnboarding = true
        showOnboarding = false
        saveStats()
    }
    
    func hideSplash() {
        showSplash = false
    }
    
    func purchaseTheme(_ theme: ThemeKS) {
        purchasedThemes.insert(theme.productID)
        selectedTheme = theme
        savePurchases()
        saveTheme()
    }
    
    func selectTheme(_ theme: ThemeKS) -> Bool {
        if StoreManagerKS.shared.hasAccess(to: theme) {
            selectedTheme = theme
            saveTheme()
            return true
        }
        return false
    }
    
    func isThemePurchased(_ theme: ThemeKS) -> Bool {
        StoreManagerKS.shared.hasAccess(to: theme)
    }
    
    var filteredArticles: [ArticleKS] {
        if searchText.isEmpty {
            return articles
        }
        return articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredQuests: [QuestKS] {
        if searchText.isEmpty {
            return quests
        } else {
            return quests.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var favoriteQuests: [QuestKS] {
        quests.filter { $0.isFavorite }
    }
    
    var favoriteArticles: [ArticleKS] {
        articles.filter { $0.isFavorite }
    }
    

    
    var featuredArticle: ArticleKS? {
        articles.first { !$0.isRead }
    }
    
    var featuredQuest: QuestKS? {
        quests.first { !$0.isCompleted }
    }
    
    var dailyTip: String {
        let tips = [
            "A crown is not given, but earned through persistent effort.",
            "Every weakness transformed is a step closer to mastery.",
            "The journey of a thousand miles begins with a single step.",
            "True sovereignty comes from mastering oneself first.",
            "Wisdom is the crown jewel of the enlightened mind.",
            "Patience and persistence pave the path to coronation.",
            "Your greatest strength lies beyond your greatest weakness."
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return tips[dayOfYear % tips.count]
    }
}

private struct UserData: Codable {
    let articles: [ArticleKS]
    let quests: [QuestKS]
    let weaknesses: [WeaknessKS]
    let journalEntries: [JournalEntryKS]
}
