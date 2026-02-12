import SwiftUI

struct JournalViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderKS(title: "Journal")
                    
                    if viewModel.journalEntries.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 60))
                                .foregroundColor(colors.textSecondary.opacity(0.5))
                            
                            Text("Your journey begins here")
                                .font(.headline)
                                .foregroundColor(colors.textSecondary)
                            
                            Text("Complete quests and read articles to fill your journal")
                                .font(.subheadline)
                                .foregroundColor(colors.textSecondary.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.journalEntries) { entry in
                                    JournalEntryCardKS(entry: entry)
                                }
                            }
                            .padding()
                            Spacer(minLength: 100)
                        }
                    }
                }
            }
        }
    }
}

struct JournalEntryCardKS: View {
    let entry: JournalEntryKS
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        GlassCardKS {
            HStack(spacing: 15) {
                if let imageName = entry.imageName {
                    if imageName.contains(".") {
                        // Assume SF Symbol
                        Image(systemName: imageName)
                            .font(.title2)
                            .foregroundColor(colors.primaryAccent)
                            .frame(width: 40)
                    } else {
                        // Assume Asset Image
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                            )
                    }
                } else {
                    // Fallback
                    Image(systemName: iconForType(entry.type))
                        .font(.title2)
                        .foregroundColor(colors.primaryAccent)
                        .frame(width: 40)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.type.rawValue)
                        .font(.caption)
                        .foregroundColor(colors.primaryAccent)
                        .fontWeight(.semibold)
                    
                    Text(entry.title)
                        .font(.headline)
                        .foregroundColor(colors.textPrimary)
                    
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
            }
        }
    }
    
    func iconForType(_ type: JournalEntryKS.EntryType) -> String {
        switch type {
        case .articleRead:
            return "book.fill"
        case .questCompleted:
            return "flag.checkered"
        case .weaknessAdded:
            return "shield.slash.fill"
        case .weaknessResolved:
            return "shield.fill"
        }
    }
}

#Preview {
    JournalViewKS()
        .environmentObject(ViewModelKS())
}
