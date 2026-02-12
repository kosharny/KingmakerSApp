import SwiftUI

struct SearchViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var selectedFilter: SearchFilter = .all
    
    enum SearchFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case wisdom = "Wisdom"
        case power = "Power"
        case virtue = "Virtue"
        case court = "Court"
        case favorites = "Favorites"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderKS(title: "Search")
                    
                    VStack(spacing: 20) {
                        searchBar(colors: colors)
                        filterChips(colors: colors)
                    }
                    .padding(.vertical)
                    
                    resultsArea(colors: colors)
                }
            }
        }
    }
    
    @ViewBuilder
    private func searchBar(colors: ThemeColorsKS) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(colors.textSecondary)
            
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search the realm...")
                        .foregroundColor(colors.textSecondary.opacity(0.5))
                }
                TextField("", text: $viewModel.searchText)
                    .foregroundColor(colors.textPrimary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colors.primaryAccent.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func filterChips(colors: ThemeColorsKS) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SearchFilter.allCases) { filter in
                    Button(action: {
                        withAnimation {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedFilter == filter ? colors.primaryAccent : colors.cardBackground)
                            )
                            .foregroundStyle(selectedFilter == filter ? AnyShapeStyle(colors.background) : AnyShapeStyle(colors.textPrimary))
                            .overlay(
                                Capsule()
                                    .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func resultsArea(colors: ThemeColorsKS) -> some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                searchResultsList(colors: colors)
            }
            .padding()
            .padding(.bottom, 80)
        }
    }

    @ViewBuilder
    private func searchResultsList(colors: ThemeColorsKS) -> some View {
        let articles = viewModel.filteredArticles
        let quests = viewModel.filteredQuests
        
        // Show articles if filter matches
        ForEach(articles) { article in
            if shouldShowArticle(article) {
                NavigationLink(destination: DetailsViewKS(item: .article(article))) {
                    SearchResultCardKS(
                        title: article.title,
                        description: article.description,
                        icon: "book.fill",
                        isCompleted: article.isRead,
                        imageName: article.imageName
                    )
                }
            }
        }
        
        // Show quests if filter matches
        ForEach(quests) { quest in
            if shouldShowQuest(quest) {
                NavigationLink(destination: DetailsViewKS(item: .quest(quest))) {
                    SearchResultCardKS(
                        title: quest.title,
                        description: quest.description,
                        icon: "flag.fill",
                        isCompleted: quest.isCompleted,
                        imageName: quest.imageName
                    )
                }
            }
        }
    }
    
    private func shouldShowArticle(_ article: ArticleKS) -> Bool {
        switch selectedFilter {
        case .all: return true
        case .wisdom, .power, .virtue, .court: 
            return article.category.lowercased() == selectedFilter.rawValue.lowercased()
        case .favorites: return article.isFavorite
        }
    }
    
    private func shouldShowQuest(_ quest: QuestKS) -> Bool {
        switch selectedFilter {
        case .all: return true
        case .wisdom, .power, .virtue, .court: 
            return quest.category.lowercased() == selectedFilter.rawValue.lowercased()
        case .favorites: return quest.isFavorite
        }
    }
}

struct SearchResultCardKS: View {
    let title: String
    let description: String
    let icon: String
    let isCompleted: Bool
    let imageName: String?
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        GlassCardKS {
            HStack(spacing: 15) {
                if let imageName = imageName, !imageName.isEmpty {
                   Image(imageName)
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: 50, height: 50)
                       .clipShape(RoundedRectangle(cornerRadius: 10))
                       .overlay(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                       )
               } else {
                   Image(systemName: icon)
                       .font(.title2)
                       .foregroundColor(colors.primaryAccent)
                       .frame(width: 40)
               }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(colors.textPrimary)
                        
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(colors.secondaryAccent)
                                .font(.caption)
                        }
                    }
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(colors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(colors.textSecondary)
            }
        }
    }
}

#Preview {
    SearchViewKS()
        .environmentObject(ViewModelKS())
}
