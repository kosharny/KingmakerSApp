import SwiftUI

struct FavoritesViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderKS(title: "Favorites")
                    
                    // Filter Picker
                    Picker("Filter", selection: $selectedFilter) {
                        Text("Articles").tag(FavoritesFilter.articles)
                        Text("Quests").tag(FavoritesFilter.quests)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onAppear {
                        // Customizing Segmented Control Appearance
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(colors.primaryAccent)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(colors.textPrimary)], for: .normal)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            if selectedFilter == .articles {
                                if viewModel.favoriteArticles.isEmpty {
                                    emptyState(icon: "book.closed.fill", text: "No favorite articles yet", color: colors.textSecondary)
                                } else {
                                    ForEach(viewModel.favoriteArticles) { article in
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
                            } else {
                                if viewModel.favoriteQuests.isEmpty {
                                    emptyState(icon: "flag.slash.fill", text: "No favorite quests yet", color: colors.textSecondary)
                                } else {
                                    ForEach(viewModel.favoriteQuests) { quest in
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
                        }
                        .padding()
                        .padding(.bottom, 80)
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func emptyState(icon: String, text: String, color: Color) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(color.opacity(0.5))
            
            Text(text)
                .font(.headline)
                .foregroundColor(color)
            
            Text("Tap the star icon to add to favorites")
                .font(.subheadline)
                .foregroundColor(color.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(height: 400)
    }
    
    @State private var selectedFilter: FavoritesFilter = .articles
    
    enum FavoritesFilter {
        case articles, quests
    }
}

#Preview {
    FavoritesViewKS()
        .environmentObject(ViewModelKS())
}
