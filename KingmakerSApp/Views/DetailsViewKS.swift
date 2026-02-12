import SwiftUI

enum ContentItemKS {
    case article(ArticleKS)
    case quest(QuestKS)
}

struct DetailsViewKS: View {
    let item: ContentItemKS
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    @State private var showQuestFlow = false
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 15) {
                        // Main Feature Image
                        if !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: colors.glowColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        } else {
                            // Fallback Icon
                             Image(systemName: iconName)
                                .font(.system(size: 60))
                                .foregroundColor(colors.primaryAccent)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        }
                        
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(colors.textPrimary)
                        
                        Text(description)
                            .font(.headline)
                            .foregroundColor(colors.textSecondary)
                        
                        Divider()
                            .background(colors.primaryAccent.opacity(0.3))
                        
                        contentView
                    }
                    .padding(.horizontal)
                    .padding(.top, 80) // Add padding for the fixed header
                    
                    actionButton
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                }
            }
            
            // Fixed Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(colors.primaryAccent)
                        .contentShape(Rectangle())
                        .frame(width: 44, height: 44) // Explicit hit area size
                        .background(colors.background.opacity(0.8).blur(radius: 5)) // Optional background for visibility
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(colors.primaryAccent)
                        .contentShape(Rectangle())
                        .frame(width: 44, height: 44) // Explicit hit area size
                        .background(colors.background.opacity(0.8).blur(radius: 5))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 30) // Adjust for safe area/notch
            .padding(.bottom, 10)
            .background(
                colors.background
                    .opacity(0.8)
                    .blur(radius: 10)
                    .ignoresSafeArea()
            )
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showQuestFlow) {
            if case .quest(let quest) = item {
                QuestFlowViewKS(quest: quest)
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
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PopToRoot"))) { _ in
            dismiss()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        switch item {
        case .article(let article):
            VStack(alignment: .leading, spacing: 15) {
                ForEach(article.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                    Text(paragraph)
                        .font(.body)
                        .foregroundColor(colors.textPrimary)
                        .lineSpacing(6)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(colors.cardBackground.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        case .quest(let quest):
            VStack(alignment: .leading, spacing: 20) {
                Text("Quest Steps")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colors.textPrimary)
                
                ForEach(Array(quest.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 20) {
                        // Timeline Indicator
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(index <= quest.currentStep ? colors.secondaryAccent : colors.cardBackground)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(colors.primaryAccent, lineWidth: 1.5)
                                    )
                                    .shadow(color: index <= quest.currentStep ? colors.glowColor.opacity(0.5) : .clear, radius: 5)
                                
                                if index < quest.currentStep {
                                    Image(systemName: "checkmark")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.textPrimary)
                                } else if index == quest.currentStep {
                                    Circle()
                                        .fill(colors.primaryAccent)
                                        .frame(width: 10, height: 10)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.textSecondary)
                                }
                            }
                            
                            // Line connector (don't show for last item)
                            if index < quest.steps.count - 1 {
                                Rectangle()
                                    .fill(index < quest.currentStep ? colors.secondaryAccent : colors.primaryAccent.opacity(0.3))
                                    .frame(width: 2)
                                    .frame(minHeight: 40)
                            }
                        }
                        
                        // Content
                        VStack(alignment: .leading, spacing: 5) {
                            Text(step)
                                .font(.body)
                                .foregroundColor(index < quest.currentStep ? colors.textSecondary : colors.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(colors.cardBackground.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(colors.primaryAccent.opacity(index == quest.currentStep ? 0.5 : 0.1), lineWidth: 1)
                                )
                        )
                        .opacity(index <= quest.currentStep + 1 ? 1.0 : 0.6) // Fade out future steps slightly
                        .scaleEffect(index == quest.currentStep ? 1.02 : 1.0) // Highlight current step
                        .offset(x: showQuestFlow ? 0 : 20) // Slide in animation
                        .animation(.spring().delay(Double(index) * 0.1), value: showQuestFlow)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var actionButton: some View {
        switch item {
        case .article(let article):
            if !article.isRead {
                RoyalButtonKS(title: "Mark as Read") {
                    viewModel.markArticleAsRead(article.id)
                    dismiss()
                }
            }
        case .quest(let quest):
            if !quest.isCompleted {
                RoyalButtonKS(title: "Start Quest") {
                    showQuestFlow = true
                }
            } else {
                Text("Quest Completed ✓")
                    .font(.headline)
                    .foregroundColor(ThemeColorsKS.colors(for: viewModel.selectedTheme).primaryAccent)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .stroke(ThemeColorsKS.colors(for: viewModel.selectedTheme).primaryAccent, lineWidth: 1)
                    )
            }
        }
    }
    
    private var title: String {
        switch item {
        case .article(let article): return article.title
        case .quest(let quest): return quest.title
        }
    }
    
    private var description: String {
        switch item {
        case .article(let article): return article.description
        case .quest(let quest): return quest.description
        }
    }
    
    private var imageName: String {
        switch item {
        case .article(let article): return article.imageName
        case .quest(let quest): return quest.imageName
        }
    }
    
    private var iconName: String {
        switch item {
        case .article: return "book.fill"
        case .quest: return "flag.fill"
        }
    }
    
    private var isFavorite: Bool {
        switch item {
        case .article(let article): return article.isFavorite
        case .quest(let quest): return quest.isFavorite
        }
    }
    
    private func toggleFavorite() {
        switch item {
        case .article(let article):
            viewModel.toggleArticleFavorite(article.id)
        case .quest(let quest):
            viewModel.toggleQuestFavorite(quest.id)
        }
    }
}

#Preview {
    DetailsViewKS(item: .article(ArticleKS(
        id: "1",
        title: "The Path to Mastery",
        description: "A deep exploration",
        content: "Long content here...",
        imageName: "article",
        category: "Wisdom",
        isFavorite: false,
        isRead: false
    )))
    .environmentObject(ViewModelKS())
}
