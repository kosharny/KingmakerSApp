import SwiftUI

struct FinishViewKS: View {
    let questTitle: String
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 100))
                    .foregroundColor(colors.primaryAccent)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Quest Completed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colors.textPrimary)
                    .opacity(opacity)
                
                Text(questTitle)
                    .font(.title3)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(opacity)
                
                GlassCardKS {
                    VStack(spacing: 15) {
                        Text("You have grown stronger")
                            .font(.headline)
                            .foregroundColor(colors.textPrimary)
                        
                        Text("+50 Activity Score")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colors.primaryAccent)
                        
                        Text("Your coronation progress has increased")
                            .font(.caption)
                            .foregroundColor(colors.textSecondary)
                    }
                }
                .padding(.horizontal)
                .opacity(opacity)
                
                Spacer()
                
                RoyalButtonKS(title: "Continue Journey") {
                    NotificationCenter.default.post(name: Notification.Name("PopToRoot"), object: nil)
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
                .padding(.horizontal)
                .opacity(opacity)
            }
            .padding(.vertical, 50)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    FinishViewKS(questTitle: "Master Your Fear")
        .environmentObject(ViewModelKS())
}
