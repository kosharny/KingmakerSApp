import SwiftUI

struct OnboardingViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            imageName: "onboarding_coronation",
            title: "Welcome to Your Coronation",
            description: "Embark on a journey of personal mastery and transformation. Track your weaknesses, complete quests, and earn your crown."
        ),
        OnboardingPage(
            imageName: "onboarding_wisdom",
            title: "Wisdom Through Reading",
            description: "Explore deep philosophical and historical articles that illuminate the path to mastery. Each article is a step toward enlightenment."
        ),
        OnboardingPage(
            imageName: "onboarding_quests",
            title: "Quests for Growth",
            description: "Complete structured six-step quests designed to transform your weaknesses into strengths. Every quest brings you closer to coronation."
        )
    ]
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            // Image Implementation
                            if let imageName = pages[index].imageName {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: colors.glowColor.opacity(0.3), radius: 10)
                                    .padding(.horizontal)
                            } else {
                                // Fallback if image missing
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(colors.primaryAccent)
                            }
                            
                            Text(pages[index].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(colors.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .foregroundColor(colors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(colors.primaryAccent)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    Capsule()
                                        .stroke(colors.primaryAccent, lineWidth: 2)
                                )
                    }
                    .padding(.horizontal, 40)
                    .transition(.opacity)
                } else {
                    RoyalButtonKS(title: "Begin Your Journey") {
                        viewModel.completeOnboarding()
                    }
                    .padding(.horizontal, 40)
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 50)
            
            // Top-trailing Skip button for all slides for better UX accessibility
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.completeOnboarding()
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary)
                            .padding()
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
        }
    }
}

struct OnboardingPage {
    let imageName: String?
    let title: String
    let description: String
}

#Preview {
    OnboardingViewKS()
        .environmentObject(ViewModelKS())
}
