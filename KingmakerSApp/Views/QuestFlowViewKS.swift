import SwiftUI

struct QuestFlowViewKS: View {
    let quest: QuestKS
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    @State private var currentStep = 0
    @State private var showFinish = false
    @State private var direction: Int = 1 // 1 for forward, -1 for backward
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // customized header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(colors.textPrimary)
                            .padding(10)
                            .background(colors.cardBackground)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("QUEST IN PROGRESS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(colors.primaryAccent)
                        .tracking(2)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Image(systemName: "xmark")
                        .font(.title3)
                        .opacity(0)
                        .padding(10)
                }
                .padding()
                
                // Progress Bar
                ProgressView(value: Double(currentStep + 1), total: Double(quest.steps.count))
                    .tint(colors.primaryAccent)
                    .scaleEffect(y: 2)
                    .padding(.horizontal)
                
                Spacer()
                
                // Content Area
                VStack(spacing: 40) {
                    // Animated Step Indicator
                    ZStack {
                        Circle()
                            .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 2)
                            .frame(width: 150, height: 150)
                        
                        Circle()
                            .trim(from: 0, to: Double(currentStep + 1) / Double(quest.steps.count))
                            .stroke(colors.primaryAccent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(), value: currentStep)
                        
                        VStack(spacing: 2) {
                            Text("\(currentStep + 1)")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(colors.textPrimary)
                            
                            Text("of \(quest.steps.count)")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(colors.textSecondary)
                        }
                    }
                    .shadow(color: colors.glowColor.opacity(0.5), radius: 20)
                    
                    // Step Content Card
                    if currentStep < quest.steps.count {
                        GlassCardKS {
                            VStack(spacing: 20) {
                                Text(quest.steps[currentStep])
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(8)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 200)
                        }
                        .padding(.horizontal)
                        .transition(.asymmetric(
                            insertion: .move(edge: direction > 0 ? .trailing : .leading).combined(with: .opacity),
                            removal: .move(edge: direction > 0 ? .leading : .trailing).combined(with: .opacity)
                        ))
                        .id(currentStep) // Force transition on change
                    }
                }
                
                Spacer()
                
                // Footer Buttons
                VStack(spacing: 20) {
                    if currentStep < quest.steps.count - 1 {
                        RoyalButtonKS(title: "Complete Step") {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                direction = 1
                                currentStep += 1
                                viewModel.updateQuestStep(quest.id, step: currentStep)
                            }
                        }
                    } else {
                        RoyalButtonKS(title: "Claim Victory") {
                            viewModel.completeQuest(quest.id)
                            showFinish = true
                        }
                    }
                    
                    if currentStep > 0 {
                        Button("Previous Step") {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                direction = -1
                                currentStep -= 1
                            }
                        }
                        .foregroundColor(colors.textSecondary)
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showFinish) {
            FinishViewKS(questTitle: quest.title)
        }
        .onAppear {
            currentStep = quest.currentStep
        }
    }
}

#Preview {
    QuestFlowViewKS(quest: QuestKS(
        id: "1",
        title: "Master Your Fear",
        description: "Transform fear into courage",
        steps: Array(repeating: "Step description", count: 6),
        imageName: "quest",
        category: "Virtue",
        isCompleted: false,
        currentStep: 0,
        isFavorite: false
    ))
    .environmentObject(ViewModelKS())
}
