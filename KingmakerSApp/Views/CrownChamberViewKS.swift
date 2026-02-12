import SwiftUI

struct CrownChamberViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(colors.primaryAccent)
                    }
                    
                    Spacer()
                    
                    Text("Crown Chamber")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                }
                .padding()
                .background(colors.cardBackground.opacity(0.8))
                
                ScrollView {
                    VStack(spacing: 30) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 100))
                            .foregroundColor(colors.primaryAccent)
                            .padding(.top, 40)
                        
                        Text(masteryLevel)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(colors.textPrimary)
                        
                        ProgressCrownKS(progress: viewModel.userStats.coronationProgress)
                        
                        GlassCardKS {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Journey")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.textPrimary)
                                
                                MasteryStatRowKS(
                                    icon: "book.fill",
                                    label: "Articles Read",
                                    value: viewModel.userStats.articlesReadCount,
                                    total: viewModel.articles.count
                                )
                                
                                MasteryStatRowKS(
                                    icon: "flag.checkered",
                                    label: "Quests Completed",
                                    value: viewModel.userStats.questsCompletedCount,
                                    total: viewModel.quests.count
                                )
                                
                                MasteryStatRowKS(
                                    icon: "shield.fill",
                                    label: "Weaknesses Resolved",
                                    value: viewModel.weaknesses.filter { $0.isResolved }.count,
                                    total: viewModel.weaknesses.count
                                )
                                
                                Divider()
                                    .background(colors.primaryAccent.opacity(0.3))
                                
                                HStack {
                                    Text("Activity Score")
                                        .font(.headline)
                                        .foregroundColor(colors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("\(viewModel.userStats.activityScore)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.primaryAccent)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        GlassCardKS {
                            VStack(spacing: 15) {
                                Text("Mastery Wisdom")
                                    .font(.headline)
                                    .foregroundColor(colors.textPrimary)
                                
                                Text(masteryWisdom)
                                    .font(.body)
                                    .foregroundColor(colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .italic()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var masteryLevel: String {
        let progress = viewModel.userStats.coronationProgress
        if progress < 0.2 {
            return "Novice"
        } else if progress < 0.4 {
            return "Apprentice"
        } else if progress < 0.6 {
            return "Journeyman"
        } else if progress < 0.8 {
            return "Expert"
        } else if progress < 1.0 {
            return "Master"
        } else {
            return "Sovereign"
        }
    }
    
    private var masteryWisdom: String {
        let progress = viewModel.userStats.coronationProgress
        if progress < 0.2 {
            return "Every master was once a beginner. Your journey has just begun, and the path ahead is filled with opportunity for growth."
        } else if progress < 0.4 {
            return "You are making steady progress. Continue to face your weaknesses with courage and wisdom will follow."
        } else if progress < 0.6 {
            return "You have reached the midpoint of your journey. The transformation within you is becoming visible to all."
        } else if progress < 0.8 {
            return "Your mastery is evident. You have overcome many challenges and grown stronger with each trial."
        } else if progress < 1.0 {
            return "You stand at the threshold of coronation. Complete your remaining quests to claim your crown."
        } else {
            return "You have achieved mastery and earned your crown. Now use your wisdom to help others on their journey."
        }
    }
}

struct MasteryStatRowKS: View {
    let icon: String
    let label: String
    let value: Int
    let total: Int
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        HStack {
            Image(systemName: icon)
                .foregroundColor(colors.primaryAccent)
                .frame(width: 30)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(colors.textPrimary)
            
            Spacer()
            
            Text("\(value) / \(total)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(colors.textSecondary)
        }
    }
}

#Preview {
    CrownChamberViewKS()
        .environmentObject(ViewModelKS())
}
