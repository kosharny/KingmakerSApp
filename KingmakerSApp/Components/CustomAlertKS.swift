import SwiftUI

struct CustomAlertKS: View {
    let title: String
    let message: String
    let primaryButton: AlertButton?
    let secondaryButton: AlertButton?
    let colors: ThemeColorsKS // Pass colors explicitly
    
    struct AlertButton {
        let title: String
        let isPrimary: Bool
        let action: () -> Void
        
        init(title: String, isPrimary: Bool = false, action: @escaping () -> Void) {
            self.title = title
            self.isPrimary = isPrimary
            self.action = action
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.primaryAccent)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 15) {
                    if let secondary = secondaryButton {
                        Button(action: secondary.action) {
                            Text(secondary.title)
                                .font(.headline)
                                .foregroundColor(colors.textSecondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(colors.cardBackground)
                                .cornerRadius(10)
                        }
                    }
                    
                    if let primary = primaryButton {
                        Button(action: primary.action) {
                            Text(primary.title)
                                .font(.headline)
                                .foregroundColor(.black) // Contrast against accent (Gold/Silver)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(colors.primaryAccent)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(24)
            .background(
                ZStack {
                    colors.cardBackground
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(colors.primaryAccent, lineWidth: 2)
                }
            )
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(40)
        }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, alert: CustomAlertKS) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                alert
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    .zIndex(1)
            }
        }
    }
}
