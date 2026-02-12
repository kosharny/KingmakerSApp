import SwiftUI

struct WeaknessTestViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var scores: [String: Int] = ["Impatience": 0, "Fear of Failure": 0, "Pride": 0, "Laziness": 0]
    @State private var showResults = false
    
    // Simple quiz data
    let questions: [TestQuestionKS] = [
        TestQuestionKS(
            text: "When faced with a difficult task, what is your first instinct?",
            answers: [
                ("Do it immediately without planning", "Impatience"),
                ("Worry about doing it wrong", "Fear of Failure"),
                ("Think I can do it better than anyone", "Pride"),
                ("Put it off until later", "Laziness")
            ]
        ),
        TestQuestionKS(
            text: "How do you handle criticism?",
            answers: [
                ("I get angry and defensive", "Pride"),
                ("I shut down and feel worthless", "Fear of Failure"),
                ("I ignore it and move on too quickly", "Impatience"),
                ("I assume they are right so I don't have to change", "Laziness")
            ]
        ),
        TestQuestionKS(
            text: "What prevents you from achieving your goals?",
            answers: [
                ("I give up when results aren't instant", "Impatience"),
                ("I avoid taking necessary risks", "Fear of Failure"),
                ("I refuse to ask for help", "Pride"),
                ("I lack the energy to start", "Laziness")
            ]
        )
    ]
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                CustomHeaderKS(title: "Know Thyself", showBackButton: true, onBack: { dismiss() })
                
                if !showResults {
                    // Progress
                    ProgressView(value: Double(currentQuestionIndex), total: Double(questions.count))
                        .tint(colors.primaryAccent)
                        .padding(.horizontal)
                    
                    // Question
                    ScrollView {
                        VStack(spacing: 30) {
                            Text(questions[currentQuestionIndex].text)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(colors.textPrimary)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            VStack(spacing: 15) {
                                ForEach(questions[currentQuestionIndex].answers, id: \.0) { answer in
                                    Button(action: {
                                        submitAnswer(trait: answer.1)
                                    }) {
                                        HStack {
                                            Text(answer.0)
                                                .font(.body)
                                                .foregroundColor(colors.textPrimary)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(colors.primaryAccent)
                                        }
                                        .padding()
                                        .background(colors.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    // Results View
                    ResultsViewKS(scores: scores, onDismiss: { dismiss() })
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
    
    func submitAnswer(trait: String) {
        scores[trait, default: 0] += 1
        
        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            withAnimation {
                showResults = true
            }
        }
    }
}

struct ResultsViewKS: View {
    let scores: [String: Int]
    let onDismiss: () -> Void
    @EnvironmentObject var viewModel: ViewModelKS
    
    var topWeakness: String {
        scores.max(by: { $0.value < $1.value })?.key ?? "Unknown"
    }
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(colors.secondaryAccent)
                    .padding(.top, 20)
                
                Text("Analysis Complete")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.textPrimary)
                
                VStack(spacing: 10) {
                    Text("Your Primary Obstacle:")
                        .font(.subheadline)
                        .foregroundColor(colors.textSecondary)
                    
                    Text(topWeakness)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(colors.primaryAccent)
                }
                
                Text("We have identified this trait as a potential barrier to your coronation. We recommend adding it to your Weakness Tracker to begin transforming it into a strength.")
                    .font(.body)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                RoyalButtonKS(title: "Track This Weakness") {
                    let desc = getDescription(for: topWeakness)
                    viewModel.addWeakness(title: topWeakness, description: desc)
                    onDismiss()
                }
                .padding(.horizontal)
                
                Button("Discard Results") {
                    onDismiss()
                }
                .foregroundColor(colors.textSecondary)
            }
            .padding()
        }
    }
    
    func getDescription(for weakness: String) -> String {
        switch weakness {
        case "Impatience": return "A tendency to rush results, often compromising quality or stability."
        case "Fear of Failure": return "Paralysis or avoidance caused by the possibility of making a mistake."
        case "Pride": return "An overestimation of oneself that prevents learning and growth."
        case "Laziness": return "A resistance to the effort required to achieve meaningful goals."
        default: return "A personal hurdle to overcome."
        }
    }
}

struct TestQuestionKS {
    let text: String
    let answers: [(String, String)] // Answer text, Trait
}
