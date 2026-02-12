import SwiftUI

struct GlassCardKS<Content: View>: View {
    let content: Content
    @EnvironmentObject var viewModel: ViewModelKS
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: colors.glowColor.opacity(0.3), radius: 10, x: 0, y: 5)
            )
    }
}

struct RoyalButtonKS: View {
    let title: String
    let action: () -> Void
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [colors.primaryAccent, colors.secondaryAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: colors.glowColor.opacity(0.5), radius: 8, x: 0, y: 4)
                )
        }
    }
}

struct CustomHeaderKS: View {
    let title: String
    let showBackButton: Bool
    let onBack: (() -> Void)?
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var showSettings = false
    
    init(title: String, showBackButton: Bool = false, onBack: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
    }
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            // Centered Title
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(colors.textPrimary)
            
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(colors.primaryAccent)
                    }
                }
                
                Spacer()
                
                // Settings Button
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(colors.primaryAccent)
                }
            }
        }
        .padding()
        .background(colors.cardBackground.opacity(0.8))
        .navigationDestination(isPresented: $showSettings) {
             SettingsViewKS()
        }
    }
}

struct ProgressCrownKS: View {
    let progress: Double
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            Circle()
                .stroke(colors.cardBackground, lineWidth: 12)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [colors.primaryAccent, colors.secondaryAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            VStack {
                Image(systemName: "crown.fill")
                    .font(.system(size: 40))
                    .foregroundColor(colors.primaryAccent)
                
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(colors.textPrimary)
            }
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    VStack(spacing: 20) {
        GlassCardKS {
            Text("Glass Card Example")
        }
        
        RoyalButtonKS(title: "Royal Button") {}
        
        ProgressCrownKS(progress: 0.65)
    }
    .padding()
    .background(Color.black)
    .environmentObject(ViewModelKS())
}
