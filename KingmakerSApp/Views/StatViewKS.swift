import SwiftUI

struct StatViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderKS(title: "Statistics")
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            GlassCardKS {
                                VStack(spacing: 20) {
                                    Text("Coronation Progress")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.textPrimary)
                                    
                                    ProgressCrownKS(progress: viewModel.userStats.coronationProgress)
                                    
                                    Text("Continue your journey to claim your crown")
                                        .font(.caption)
                                        .foregroundColor(colors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                StatCardKS(
                                    icon: "book.fill",
                                    title: "Articles Read",
                                    value: "\(viewModel.userStats.articlesReadCount)",
                                    total: "\(viewModel.articles.count)",
                                    imageName: "study_of_law"
                                )
                                
                                StatCardKS(
                                    icon: "flag.checkered",
                                    title: "Quests Completed",
                                    value: "\(viewModel.userStats.questsCompletedCount)",
                                    total: "\(viewModel.quests.count)",
                                    imageName: "vigil_night"
                                )
                                
                                StatCardKS(
                                    icon: "star.fill",
                                    title: "Activity Score",
                                    value: "\(viewModel.userStats.activityScore)",
                                    total: "∞",
                                    imageName: "scepter_and_orb"
                                )
                                
                                StatCardKS(
                                    icon: "shield.fill",
                                    title: "Weaknesses Resolved",
                                    value: "\(viewModel.weaknesses.filter { $0.isResolved }.count)",
                                    total: "\(viewModel.weaknesses.count)",
                                    imageName: "inner_fortress"
                                )
                            }
                            .padding(.horizontal)
                            
                            NavigationLink(destination: CrownChamberViewKS()) {
                                GlassCardKS {
                                    HStack {
                                        Image(systemName: "crown.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(colors.primaryAccent)
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Enter Crown Chamber")
                                                .font(.headline)
                                                .foregroundColor(colors.textPrimary)
                                            
                                            Text("View your mastery level")
                                                .font(.caption)
                                                .foregroundColor(colors.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(colors.textSecondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
}

struct StatCardKS: View {
    let icon: String
    let title: String
    let value: String
    let total: String
    let imageName: String? 
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        GlassCardKS {
            ZStack(alignment: .leading) {
                if let imageName = imageName, !imageName.isEmpty {
                     Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        .clipped()
                        .opacity(0.15) // Subtle background
                }
                
                HStack(spacing: 15) {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(colors.primaryAccent)
                        .frame(width: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text(value)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(colors.textPrimary)
                            
                            Text("/ \(total)")
                                .font(.headline)
                                .foregroundColor(colors.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    StatViewKS()
        .environmentObject(ViewModelKS())
}
