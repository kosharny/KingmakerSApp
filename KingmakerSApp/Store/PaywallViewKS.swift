import SwiftUI
import StoreKit

struct PaywallViewKS: View {
    let theme: ThemeKS
    
    @StateObject private var store = StoreManagerKS.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        // Determine colors based on the theme being purchased
        let colors = ThemeColorsKS.colors(for: theme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            // Main Content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 20) {
                    // Theme Preview
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        colors.secondaryAccent,
                                        colors.primaryAccent
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: colors.secondaryAccent.opacity(0.5), radius: 20)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    Text(theme.rawValue)
                        .font(.custom("Times New Roman", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(colors.primaryAccent)
                    
                    Text("Unlock this exclusive premium theme")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRowKS(
                        icon: "paintpalette.fill",
                        title: "Unique Color Palette",
                        description: "Experience the app in stunning new colors",
                        accentColor: colors.primaryAccent
                    )
                    
                    FeatureRowKS(
                        icon: "sparkles",
                        title: "Exclusive Visuals",
                        description: "Enhanced UI elements and accents",
                        accentColor: colors.primaryAccent
                    )
                    
                    FeatureRowKS(
                        icon: "heart.fill",
                        title: "Support Development",
                        description: "Help us create more amazing content",
                        accentColor: colors.primaryAccent
                    )
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Purchase Section
                if let product = store.products.first(where: { $0.id == theme.productID }) {
                    VStack(spacing: 16) {
                        // Purchase Button
                        Button {
                            selectedProduct = product
                            showConfirmAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Unlock for \(product.displayPrice)")
                                    .fontWeight(.bold)
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [colors.primaryAccent, colors.primaryAccent.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: colors.primaryAccent.opacity(0.3), radius: 10)
                        }
                        
                        // Restore Button
                        Button {
                            Task {
                                await store.restorePurchases()
                                if store.hasAccess(to: theme) {
                                    resultTitle = "Success"
                                    resultMessage = "Your purchases have been restored!"
                                    isSuccess = true
                                    showResultAlert = true
                                } else {
                                    resultTitle = "No Purchases Found"
                                    resultMessage = "We couldn't find any previous purchases for this theme."
                                    isSuccess = false
                                    showResultAlert = true
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 10) {
                        if store.isLoading {
                            ProgressView()
                                .tint(colors.primaryAccent)
                            Text("Loading products...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            // If not loading, check if product ID is valid/found
                            if !theme.productID.isEmpty {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.yellow)
                                Text("Product not found")
                                    .foregroundColor(.gray)
                                Text("ID: \(theme.productID)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                
                                Button("Retry") {
                                    Task { await store.fetchProducts() }
                                }
                                .padding(.top, 5)
                            } else {
                                Text("This theme is free.")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                }
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Text("Not Now")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .customAlert(isPresented: $showResultAlert, alert: resultAlert)
        .customAlert(isPresented: $showConfirmAlert, alert: confirmAlert)
        .task {
            if store.products.isEmpty {
                await store.fetchProducts()
            }
        }
    }
    
    // Confirmation Alert
    var confirmAlert: CustomAlertKS {
        let colors = ThemeColorsKS.colors(for: theme)
        return CustomAlertKS(
            title: "Confirm Purchase",
            message: "Unlock \(theme.rawValue) for \(selectedProduct?.displayPrice ?? "")?\n\nThis is a one-time purchase.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                showConfirmAlert = false
                Task {
                    await performPurchase()
                }
            },
            secondaryButton: .init(title: "Cancel") {
                showConfirmAlert = false
            },
            colors: colors
        )
    }
    
    // Result Alert
    var resultAlert: CustomAlertKS {
        let colors = ThemeColorsKS.colors(for: theme)
        return CustomAlertKS(
            title: resultTitle,
            message: resultMessage,
            primaryButton: .init(title: "OK", isPrimary: true) {
                showResultAlert = false
                if isSuccess && store.hasAccess(to: theme) {
                    dismiss()
                }
            },
            secondaryButton: nil,
            colors: colors
        )
    }
    
    func performPurchase() async {
        guard let product = selectedProduct else { return }
        
        // Hide confirm alert first
        showConfirmAlert = false
        
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            if store.hasAccess(to: theme) {
                resultTitle = "Success!"
                resultMessage = "\(theme.rawValue) has been unlocked. Enjoy!"
                isSuccess = true
                showResultAlert = true
            }
            
        case .cancelled:
            print("User cancelled purchase")
            showResultAlert = false
            
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Your purchase is pending approval."
            isSuccess = false
            showResultAlert = true
            
        case .failed:
            resultTitle = "Purchase Failed"
            resultMessage = "We couldn't complete your purchase. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

struct FeatureRowKS: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}
