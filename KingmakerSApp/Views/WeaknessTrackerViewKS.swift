import SwiftUI

struct WeaknessTrackerViewKS: View {
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    @State private var showAddWeakness = false
    @State private var newWeaknessTitle = ""
    @State private var newWeaknessDescription = ""
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(colors.primaryAccent)
                    }
                    
                    Spacer()
                    
                    Text("Weakness Tracker")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showAddWeakness = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(colors.primaryAccent)
                    }
                }
                .padding()
                .background(colors.cardBackground.opacity(0.8))
                
                if viewModel.weaknesses.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "shield.slash.fill")
                            .font(.system(size: 60))
                            .foregroundColor(colors.textSecondary.opacity(0.5))
                        
                        Text("No weaknesses tracked")
                            .font(.headline)
                            .foregroundColor(colors.textSecondary)
                        
                        Text("Identify and track your weaknesses to transform them into strengths")
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            viewModel.seedDefaultWeaknesses()
                        }) {
                            Text("Add Examples")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(colors.primaryAccent)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .stroke(colors.primaryAccent, lineWidth: 1)
                                )
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.weaknesses) { weakness in
                                WeaknessCardKS(weakness: weakness)
                            }
                        }
                        .padding()
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddWeakness) {
            AddWeaknessSheetKS(
                title: $newWeaknessTitle,
                description: $newWeaknessDescription,
                onAdd: {
                    viewModel.addWeakness(title: newWeaknessTitle, description: newWeaknessDescription)
                    newWeaknessTitle = ""
                    newWeaknessDescription = ""
                    showAddWeakness = false
                }
            )
        }
    }
}

struct WeaknessCardKS: View {
    let weakness: WeaknessKS
    @EnvironmentObject var viewModel: ViewModelKS
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        GlassCardKS {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: weakness.isResolved ? "shield.fill" : "shield.slash.fill")
                        .foregroundColor(weakness.isResolved ? colors.secondaryAccent : colors.primaryAccent)
                    
                    Text(weakness.title)
                        .font(.headline)
                        .foregroundColor(colors.textPrimary)
                    
                    Spacer()
                    
                    if weakness.isResolved {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(colors.secondaryAccent)
                    }
                }
                
                Text(weakness.description)
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                
                if !weakness.isResolved {
                    VStack(alignment: .leading, spacing: 12) {
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(colors.textSecondary.opacity(0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        LinearGradient(
                                            colors: [colors.primaryAccent, colors.secondaryAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(geometry.size.width * weakness.progress, 0), height: 8)
                                    .animation(.spring(), value: weakness.progress)
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text("\(Int(weakness.progress * 100))% Developed")
                                .font(.caption)
                                .foregroundColor(colors.textSecondary)
                            
                            Spacer()
                            
                            if weakness.progress < 1.0 {
                                Button(action: {
                                    viewModel.developWeakness(weakness.id)
                                }) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "hammer.fill")
                                        Text("Develop")
                                    }
                                    .font(.caption)
                                    .foregroundColor(colors.primaryAccent)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(colors.primaryAccent, lineWidth: 1)
                                    )
                                }
                            } else {
                                Button(action: {
                                    viewModel.resolveWeakness(weakness.id)
                                }) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "checkmark")
                                        Text("Resolve")
                                    }
                                    .font(.caption)
                                    .foregroundColor(colors.secondaryAccent)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(colors.secondaryAccent, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                }
            }
        }
    }
}

struct AddWeaknessSheetKS: View {
    @Binding var title: String
    @Binding var description: String
    let onAdd: () -> Void
    @EnvironmentObject var viewModel: ViewModelKS
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let colors = ThemeColorsKS.colors(for: viewModel.selectedTheme)
        
        ZStack {
            colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Confront Weakness")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(colors.textSecondary)
                            .padding(8)
                            .background(colors.cardBackground)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Acknowledging a flaw is the first step to conquering it. Be honest with yourself.")
                            .font(.subheadline)
                            .foregroundColor(colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        GlassCardKS {
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("NAME THE WEAKNESS")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.primaryAccent)
                                        .tracking(1)
                                    
                                    TextField("e.g., Procrastination", text: $title)
                                        .padding()
                                        .background(colors.background.opacity(0.5))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                                        )
                                        .foregroundColor(colors.textPrimary)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("DESCRIPTION & IMPACT")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.primaryAccent)
                                        .tracking(1)
                                    
                                    TextEditor(text: $description)
                                        .frame(height: 120)
                                        .padding(8)
                                        .scrollContentBackground(.hidden) // Remove white background
                                        .background(colors.background.opacity(0.5))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(colors.primaryAccent.opacity(0.3), lineWidth: 1)
                                        )
                                        .foregroundColor(colors.textPrimary)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .padding(.horizontal)
                        
                        RoyalButtonKS(title: "Commit to Change") {
                            onAdd()
                        }
                        .padding(.horizontal)
                        .disabled(title.isEmpty || description.isEmpty)
                        .opacity(title.isEmpty || description.isEmpty ? 0.5 : 1.0)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

#Preview {
    WeaknessTrackerViewKS()
        .environmentObject(ViewModelKS())
}
