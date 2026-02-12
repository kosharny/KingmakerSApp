import SwiftUI

struct SplashViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 100))
                    .foregroundColor(colors.primaryAccent)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("KingmakerS")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                viewModel.hideSplash()
            }
        }
    }
}

#Preview {
    SplashViewKS()
        .environmentObject(ViewModelKS())
}
