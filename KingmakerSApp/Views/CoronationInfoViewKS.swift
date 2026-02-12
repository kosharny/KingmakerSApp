import SwiftUI

struct CoronationInfoViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Image / Header area
                    ZStack {
                        Image("coronation_header") // Placeholder or system image if asset missing, but let's use a nice gradient/symbol for now
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .overlay(colors.background.opacity(0.3)) // Overlay to ensure text readability
                        
                        VStack(spacing: 10) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(colors.primaryAccent)
                                .shadow(color: colors.glowColor, radius: 10)
                            
                            Text("The Path to Coronation")
                                .font(.custom("Times New Roman", size: 36)) // Using serif for that royal feel
                                .fontWeight(.bold)
                                .foregroundColor(colors.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(spacing: 30) {
                        
                        // Introduction
                        InfoSectionKS(
                            title: "The Phenomenon",
                            content: "Coronation is not merely a ceremony of placing a crown upon a head. It is the external manifestation of an internal reality: the acceptance of sovereignty over oneself. Throughout history, the crown has symbolized the highest state of being—a union of wisdom, power, and responsibility.",
                            icon: "scroll.fill"
                        )
                        
                        // History
                        InfoSectionKS(
                            title: "Ancient Roots",
                            content: "From the Pharaohs of Egypt to the Holy Roman Emperors, the act of coronation was a sacred rite. It marked the transition from a mere mortal to a divinely appointed leader. It required years of preparation, purification, and the proving of one's worthiness.",
                            icon: "building.columns.fill"
                        )
                        
                        // Philosophy
                        InfoSectionKS(
                            title: "The Inner Crown",
                            content: "In the philosophy of KingmakerS, true coronation happens within. It is the moment you conquer your baser instincts—your fear, your laziness, your pride—and choose to rule your life with reason and purpose. The physical crown is but a shadow of this inner victory.",
                            icon: "brain.head.profile"
                        )
                        
                        // Call to Action
                        GlassCardKS {
                            VStack(spacing: 15) {
                                Text("Your Journey Begins")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.primaryAccent)
                                
                                Text("You are here to forge your own crown. Every weakness you overcome is a jewel set into its band. Every quest you complete adds to its weight and glory.")
                                    .font(.body)
                                    .foregroundColor(colors.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Close Button
                        RoyalButtonKS(title: "Return to Realm") {
                            dismiss()
                        }
                        .padding(.top, 20)
                        
                    }
                    .padding(24)
                    .background(colors.background)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -30) // Overlap effect
                }
            }
        }
        .onAppear {
            withAnimation {
                viewModel.isTabBarHidden = true
            }
        }
        .onDisappear {
            withAnimation {
                viewModel.isTabBarHidden = false
            }
        }
        .navigationBarHidden(true)
    }
}

struct InfoSectionKS: View {
    let title: String
    let content: String
    let icon: String
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(colors.primaryAccent)
                    .frame(width: 40)
                    .padding(10)
                    .background(colors.cardBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1))
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.textPrimary)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(colors.textSecondary)
                .lineSpacing(6)
        }
    }
}

// Helper for corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerKS(radius: radius, corners: corners))
    }
}

struct RoundedCornerKS: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
