import SwiftUI

struct ContentView: View {
    // Main view model
    @StateObject private var viewModel = TranslationViewModel()
    
    // Update the accent color to a brighter, more vibrant red
    private let accentColor = Color(red: 231/255, green: 76/255, blue: 60/255)  // A more vivid red
    
    @State private var showingSavedTranslations = false
    
    // Define the dark gray-blue color
    private let backgroundColor = Color(red: 47/255, green: 54/255, blue: 64/255)
    private let textBoxColor = Color(red: 35/255, green: 41/255, blue: 49/255)  // Slightly lighter than pure black
    
    @State private var isTranslating = false
    @State private var textFieldScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            // Changed from ScrollView to VStack
            VStack(spacing: 50) {
                Spacer(minLength: 20)
                
                // App title
                Text("TranslateMe")
                    .font(.system(size: 50, weight: .bold))
                    .padding(.top, 50)
                
                // Language selector row
                HStack(spacing: 23) {
                    // Source language dropdown
                    Menu {
                        ForEach(Language.supportedLanguages) { language in
                            Button(action: {
                                viewModel.sourceLanguage = language
                            }) {
                                Text(language.name)
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.sourceLanguage.name)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(accentColor)
                            Image(systemName: "chevron.up.chevron.down")
                                .foregroundColor(accentColor)
                                .font(.system(size: 22))
                        }
                    }
                    
                    // Arrow between languages
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                        .font(.system(size: 20))
                    
                    // Target language dropdown
                    Menu {
                        ForEach(Language.supportedLanguages) { language in
                            Button(action: {
                                viewModel.targetLanguage = language
                            }) {
                                Text(language.name)
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.targetLanguage.name)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(accentColor)
                            Image(systemName: "chevron.up.chevron.down")
                                .foregroundColor(accentColor)
                                .font(.system(size: 22))
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Main translation area
                VStack(alignment: .leading, spacing: 40) {
                    // Source text area
                    VStack(alignment: .leading) {
                        Text(viewModel.sourceLanguage.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        TextEditor(text: $viewModel.originalText)
                            .frame(height: 110)
                            .padding(8)
                            .background(textBoxColor)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                                    .scaleEffect(textFieldScale)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: textFieldScale)
                            )
                            .shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 0)
                            .font(.system(size: 19))
                            .tint(accentColor)
                            .onTapGesture {
                                withAnimation {
                                    textFieldScale = 1.02
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            textFieldScale = 1.0
                                        }
                                    }
                                }
                            }
                    }
                    
                    // Translate button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isTranslating = true
                        }
                        viewModel.translate()
                        
                        // Reset animation after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                isTranslating = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "translate")
                                .rotationEffect(.degrees(isTranslating ? 360 : 0))
                            Text("Translate to \(viewModel.targetLanguage.name)")
                                .font(.system(size: 23))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.originalText.isEmpty ? accentColor.opacity(0.6) : accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .scaleEffect(isTranslating ? 0.95 : 1.0)
                    }
                    .disabled(viewModel.originalText.isEmpty || viewModel.isLoading)
                    .animation(.easeInOut, value: viewModel.originalText.isEmpty)
                    
                    // Translation output area
                    VStack(alignment: .leading) {
                        Text(viewModel.targetLanguage.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        TextEditor(text: .constant(viewModel.translatedText))
                            .frame(height: 110)
                            .padding(8)
                            .background(textBoxColor)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                            )
                            .shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 0)
                            .font(.system(size: 19))
                            .tint(accentColor)
                    }
                }
                .padding(.horizontal)
                
                // View Saved Translations Button
                NavigationLink {
                    SavedTranslationsView(viewModel: viewModel)
                        .navigationBarHidden(true)
                } label: {
                    Text("View Saved Translations")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 30)
                        .background(Color(red: 37/255, green: 42/255, blue: 50/255))
                        .cornerRadius(50)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer(minLength: 50)
            }
            // View modifiers
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .background(backgroundColor)
            .ignoresSafeArea(.keyboard)
            .ignoresSafeArea(.all)
        }
        .background(backgroundColor)
        .ignoresSafeArea(.all)
    }
}

#Preview{
    ContentView()
}
