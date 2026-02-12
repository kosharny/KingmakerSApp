import SwiftUI

struct MainViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var selectedTab = 0
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        Group {
            if viewModel.showSplash {
                SplashViewKS()
            } else if viewModel.showOnboarding {
                OnboardingViewKS()
            } else {
                ZStack {
                    colors.background
                        .ignoresSafeArea()
                    
                    ZStack(alignment: .bottom) {
                        Group {
                            switch selectedTab {
                            case 0:
                                HomeViewKS()
                            case 1:
                                JournalViewKS()
                            case 2:
                                SearchViewKS()
                            case 3:
                                FavoritesViewKS()
                            case 4:
                                StatViewKS()
                            default:
                                HomeViewKS()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        if !viewModel.isTabBarHidden {
                            CustomTabBarKS(selectedTab: $selectedTab)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct CustomTabBarKS: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var viewModel: ViewModelKS
    
    let tabs = [
        TabItem(icon: "house.fill", title: "Home"),
        TabItem(icon: "book.fill", title: "Journal"),
        TabItem(icon: "magnifyingglass", title: "Search"),
        TabItem(icon: "star.fill", title: "Favorites"),
        TabItem(icon: "chart.bar.fill", title: "Stats")
    ]
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 20))
                            .symbolVariant(selectedTab == index ? .fill : .none)
                        
                        Text(tabs[index].title)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == index ? colors.primaryAccent : colors.textSecondary)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 5)
        .background(
            Capsule()
                .fill(colors.cardBackground.opacity(0.95))
                .shadow(color: colors.glowColor.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [colors.primaryAccent, colors.secondaryAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10) // Lift from bottom
    }
}

struct TabItem {
    let icon: String
    let title: String
}

#Preview {
    MainViewKS()
        .environmentObject(ViewModelKS())
}
