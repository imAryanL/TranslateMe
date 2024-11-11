import SwiftUI

struct SavedTranslationsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TranslationViewModel
    let accentColor = Color(red: 231/255, green: 76/255, blue: 60/255)
    private let backgroundColor = Color(red: 47/255, green: 54/255, blue: 64/255)
    @State private var isClearing = false
    @State private var appearingCards: Set<UUID> = []
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Navigation Bar (Fixed)
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .font(.system(size: 18))
                            .foregroundColor(accentColor)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    Text("Saved Translations")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold))
                    
                    Spacer()
                    
                    // Empty space to maintain centering
                    Text("Close")
                        .opacity(0)
                        .padding(.trailing)
                }
                .padding(.vertical, 15)
                
                // Scrollable Translations List
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(viewModel.translationHistory) { item in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(item.fromLanguage) → \(item.toLanguage)")
                                    .foregroundColor(accentColor)
                                    .font(.system(size: 18))
                                
                                Text(item.translatedText)
                                    .foregroundColor(.white)
                                    .font(.system(size: 22))
                                
                                Text(item.originalText)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                            }
                            .padding()
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 37/255, green: 42/255, blue: 50/255))
                            .cornerRadius(8)
                            .opacity(appearingCards.contains(item.id) ? 1 : 0)
                            .offset(y: appearingCards.contains(item.id) ? 0 : 50)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7).delay(Double(viewModel.translationHistory.firstIndex(where: { $0.id == item.id }) ?? 0) * 0.1), value: appearingCards.contains(item.id))
                            .onAppear {
                                appearingCards.insert(item.id)
                            }
                        }
                    }
                    .padding()
                }
                
                // Clear All Translations Button (Fixed at bottom)
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isClearing = true
                    }
                    
                    // Add slight delay before clearing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            viewModel.clearTranslationHistory()
                            appearingCards.removeAll()
                            isClearing = false
                        }
                    }
                }) {
                    Text("Clear All Translations")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 30)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    accentColor,
                                    accentColor.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(50)
                        .scaleEffect(isClearing ? 0.95 : 1.0)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let viewModel = TranslationViewModel()
    // Add some sample data for the preview
    viewModel.translationHistory = [
        TranslationHistoryItem(
            originalText: "Hello",
            translatedText: "Ciao",
            fromLanguage: "English",
            toLanguage: "Italian",
            date: Date()
        ),
        TranslationHistoryItem(
            originalText: "Good morning",
            translatedText: "Buongiorno",
            fromLanguage: "English",
            toLanguage: "Italian",
            date: Date()
        ),
        // Add more items to test scrolling
        TranslationHistoryItem(
            originalText: "How are you?",
            translatedText: "Come stai?",
            fromLanguage: "English",
            toLanguage: "Italian",
            date: Date()
        )
    ]
    return SavedTranslationsView(viewModel: viewModel)
} 
