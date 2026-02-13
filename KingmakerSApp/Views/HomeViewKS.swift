import SwiftUI

struct HomeViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var showSettings = false
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Welcome, Future Sovereign")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(colors.textPrimary)
                            
                            Text("Your journey to mastery continues")
                                .font(.subheadline)
                                .foregroundColor(colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(colors.primaryAccent)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    GlassCardKS {
                        VStack(spacing: 15) {
                            Text("Coronation Progress")
                                .font(.headline)
                                .foregroundColor(colors.textPrimary)
                            
                            ProgressCrownKS(progress: viewModel.userStats.coronationProgress)
                            
                            Text("You are \(Int(viewModel.userStats.coronationProgress * 100))% of the way to your coronation")
                                .font(.caption)
                                .foregroundColor(colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    GlassCardKS {
                        ZStack(alignment: .leading) {
                            // Background Image
                            Image("daily_wisdom_bg")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(15)
                                .opacity(0.4) // Subtle background
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(colors.primaryAccent)
                                    Text("Daily Wisdom")
                                        .font(.headline)
                                        .foregroundColor(colors.textPrimary)
                                }
                                
                                Text(viewModel.dailyTip)
                                    .font(.body)
                                    .foregroundColor(colors.textSecondary)
                                    .italic()
                                    .shadow(color: Color.black, radius: 2) // Ensure readability
                            }
                            .padding()
                        }
                        .padding(-16) // Negate padding to let image fill
                    }
                    .padding(.horizontal)
                    
                    // New Feature Cards
                    HStack(spacing: 15) {
                        NavigationLink(destination: CoronationInfoViewKS()) {
                            RoyalFeatureCardKS(
                                title: "Coronation\nPhenomenon",
                                subtitle: "The Path to Power",
                                icon: "crown.fill"
                            )
                        }
                        
                        NavigationLink(destination: WeaknessTestViewKS()) {
                            RoyalFeatureCardKS(
                                title: "Know\nThyself",
                                subtitle: "Weakness Test",
                                icon: "eye.fill"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    if let featured = viewModel.featuredArticle {
                        NavigationLink(destination: DetailsViewKS(item: .article(featured))) {
                            FeaturedCardKS(
                                title: featured.title,
                                description: featured.description,
                                icon: "book.fill",
                                type: "Featured Article",
                                imageName: featured.imageName
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    if let featured = viewModel.featuredQuest {
                        NavigationLink(destination: DetailsViewKS(item: .quest(featured))) {
                            FeaturedCardKS(
                                title: featured.title,
                                description: featured.description,
                                icon: "flag.fill",
                                type: "Featured Quest",
                                imageName: featured.imageName
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    NavigationLink(destination: WeaknessTrackerViewKS()) {
                        GlassCardKS {
                            HStack {
                                Image(systemName: "shield.fill")
                                    .font(.title)
                                    .foregroundColor(colors.primaryAccent)
                                
                                VStack(alignment: .leading) {
                                    Text("Weakness Tracker")
                                        .font(.headline)
                                        .foregroundColor(colors.textPrimary)
                                    Text("Transform your weaknesses")
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
                    
                    Spacer(minLength: 100)
                }
            }
            .background(colors.background.ignoresSafeArea())
            .navigationDestination(isPresented: $showSettings) {
                SettingsViewKS()
            }
        }
    }
}

struct FeaturedCardKS: View {
    let title: String
    let description: String
    let icon: String
    let type: String
    let imageName: String
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        GlassCardKS {
            VStack(alignment: .leading, spacing: 0) {
                // Image Header
                if !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [colors.cardBackground.opacity(0), colors.cardBackground],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(colors.primaryAccent)
                        Text(type)
                            .font(.caption)
                            .foregroundColor(colors.primaryAccent)
                            .fontWeight(.semibold)
                    }
                    
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(colors.textSecondary)
                        .lineLimit(2)
                    
                    HStack {
                        Spacer()
                        Text("Begin →")
                            .font(.subheadline)
                            .foregroundColor(colors.primaryAccent)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
            }
            .padding(-16) // Negate specific GlassCard padding to make image full width
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct RoyalFeatureCardKS: View {
    let title: String
    let subtitle: String
    let icon: String
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 20)
                .fill(colors.cardBackground)
                .shadow(color: colors.glowColor.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [colors.primaryAccent.opacity(0.6), colors.secondaryAccent.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            // Watermark Icon
            GeometryReader { geo in
                Image(systemName: icon)
                    .font(.system(size: 100))
                    .foregroundColor(colors.primaryAccent.opacity(0.05))
                    .rotationEffect(.degrees(-20))
                    .position(x: geo.size.width * 0.85, y: geo.size.height * 0.3)
                    .clipped()
            }
            // Content
            VStack(alignment: .leading, spacing: 10) {
                // Icon Badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colors.primaryAccent.opacity(0.2), colors.secondaryAccent.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(colors.primaryAccent)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(colors.textSecondary)
                        .lineLimit(1)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 170)
    }
}

#Preview {
    HomeViewKS()
        .environmentObject(ViewModelKS())
}
