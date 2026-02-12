import SwiftUI

struct SettingsViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    @State private var showAbout = false
    @State private var showPaywall: ThemeKS? = nil
    
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
                    
                    Text("Settings")
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
                    VStack(spacing: 20) {
                        GlassCardKS {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Theme Selection")
                                    .font(.headline)
                                    .foregroundColor(colors.textPrimary)
                                
                                ForEach(ThemeKS.allCases, id: \.self) { theme in
                                    ThemeOptionKS(theme: theme, onSelect: {
                                        if !viewModel.selectTheme(theme) {
                                            showPaywall = theme
                                        }
                                    })
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Restore Purchases Button
                        Button(action: {
                            Task {
                                await StoreManagerKS.shared.restorePurchases()
                            }
                        }) {
                            Text("Restore Purchases")
                                .font(.subheadline)
                                .foregroundColor(colors.textSecondary)
                                .padding(.vertical, 8)
                        }
                        
                        Button(action: { showAbout = true }) {
                            GlassCardKS {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(colors.primaryAccent)
                                    
                                    Text("About KingmakerS")
                                        .font(.headline)
                                        .foregroundColor(colors.textPrimary)
                                    
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
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showAbout) {
            AboutViewKS()
        }
        .sheet(item: $showPaywall) { theme in
            PaywallViewKS(theme: theme)
        }
    }
}

struct ThemeOptionKS: View {
    let theme: ThemeKS
    let onSelect: () -> Void
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        let isSelected = viewModel.selectedTheme == theme
        let isPurchased = viewModel.isThemePurchased(theme)
        
        Button(action: onSelect) {
            HStack(spacing: 15) {
                Circle()
                    .fill(themePreviewColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(colors.primaryAccent, lineWidth: isSelected ? 3 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(theme.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(colors.textPrimary)
                        
                        if theme.isPremium && !isPurchased {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(colors.primaryAccent)
                        }
                    }
                    
                    Text(theme.price)
                        .font(.caption)
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(colors.primaryAccent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.cardBackground.opacity(0.3))
            )
        }
    }
    
    private var themePreviewColor: LinearGradient {
        switch theme {
        case .royalDefault:
            return LinearGradient(colors: [Color(hex: "D4AF37"), Color(hex: "9B7EBD")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .obsidianThrone:
            return LinearGradient(colors: [Color(hex: "C0C0C0"), Color(hex: "6A5ACD")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .crimsonEmpire:
            return LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "DC143C")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    SettingsViewKS()
        .environmentObject(ViewModelKS())
}
