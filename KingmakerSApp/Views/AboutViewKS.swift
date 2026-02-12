import SwiftUI

struct AboutViewKS: View {
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
                            .font(.title3)
                            .foregroundColor(colors.textPrimary)
                    }
                    
                    Spacer()
                    
                    Text("About")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .font(.title3)
                        .opacity(0)
                }
                .padding()
                .background(colors.cardBackground.opacity(0.8))
                
                ScrollView {
                    VStack(spacing: 30) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 80))
                            .foregroundColor(colors.primaryAccent)
                            .padding(.top, 40)
                        
                        Text("KingmakerS")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(colors.textPrimary)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary)
                        
                        GlassCardKS {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("About This App")
                                    .font(.headline)
                                    .foregroundColor(colors.textPrimary)
                                
                                Text("KingmakerS is your companion on the journey to personal mastery. Through deep philosophical articles, structured quests, and weakness tracking, you will transform yourself and earn your crown.")
                                    .font(.body)
                                    .foregroundColor(colors.textSecondary)
                                    .lineSpacing(6)
                                
                                Text("The path to coronation is not easy, but it is rewarding. Every step you take brings you closer to becoming the sovereign of your own life.")
                                    .font(.body)
                                    .foregroundColor(colors.textSecondary)
                                    .lineSpacing(6)
                            }
                        }
                        .padding(.horizontal)
                        
                        GlassCardKS {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Features")
                                    .font(.headline)
                                    .foregroundColor(colors.textPrimary)
                                
                                AboutFeatureRowKS(icon: "book.fill", text: "18 Deep Philosophical Articles")
                                AboutFeatureRowKS(icon: "flag.fill", text: "18 Transformative Quests")
                                AboutFeatureRowKS(icon: "shield.fill", text: "Weakness Tracking System")
                                AboutFeatureRowKS(icon: "crown.fill", text: "Coronation Progress")
                                AboutFeatureRowKS(icon: "paintbrush.fill", text: "3 Premium Themes")
                                AboutFeatureRowKS(icon: "iphone", text: "Fully Offline")
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
}

struct AboutFeatureRowKS: View {
    let icon: String
    let text: String
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(colors.primaryAccent)
                .frame(width: 25)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(colors.textPrimary)
        }
    }
}

#Preview {
    AboutViewKS()
        .environmentObject(ViewModelKS())
}
