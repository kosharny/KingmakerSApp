import SwiftUI

struct PurchaseCardViewKS: View {
    let title: String
    let price: String
    let description: String
    let isLocked: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white) // Always white for contrast on dark card
                Spacer()
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text(price)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "D4AF37")) // Gold
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(hex: "2C0B0E")) // Dark Crimson/Brown background
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isLocked ? Color.gray : Color(hex: "D4AF37"), lineWidth: 1)
        )
    }
}
