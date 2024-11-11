import Foundation

class TranslationViewModel: ObservableObject {
    // Published properties allow the UI to update automatically when these values change
    @Published var originalText = ""            // Stores the text to be translated
    @Published var translatedText = ""          // Stores the translated result
    @Published var isLoading = false            // Tracks if translation is in progress
    @Published var errorMessage: String?        // Stores any error messages
    
    // Default language selections when app starts
    @Published var sourceLanguage = Language.supportedLanguages[0]  // First language (English)
    @Published var targetLanguage = Language.supportedLanguages[1]  // Second language (Italian)
    
    // Array to store translation history
    @Published var translationHistory: [TranslationHistoryItem] = []
    
    // Main translation function
    func translate() {
        // Don't translate if there's no text
        guard !originalText.isEmpty else { return }
        
        // Show loading indicator
        isLoading = true
        
        // Create the URL for the API request
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")
        
        // Add query parameters to the URL
        components?.queryItems = [
            URLQueryItem(name: "q", value: originalText),                                  // Text to translate
            URLQueryItem(name: "langpair", value: "\(sourceLanguage.code)|\(targetLanguage.code)")  // Language pair
        ]
        
        // Make sure we have a valid URL
        guard let url = components?.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        // Create and start the network request
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Switch back to main thread for UI updates
            DispatchQueue.main.async {
                // Hide loading indicator
                self?.isLoading = false
                
                // Handle any network errors
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                // Make sure we received data
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                // Try to decode the API response
                do {
                    // Convert JSON response to our TranslationResponse type
                    let response = try JSONDecoder().decode(TranslationResponse.self, from: data)
                    // Update the translated text
                    self?.translatedText = response.responseData.translatedText
                    
                    // Add successful translation to history
                    if let self = self {
                        // Create a new history item
                        let historyItem = TranslationHistoryItem(
                            originalText: self.originalText,
                            translatedText: response.responseData.translatedText,
                            fromLanguage: self.sourceLanguage.name,
                            toLanguage: self.targetLanguage.name,
                            date: Date()
                        )
                        // Add new translation to the beginning of history
                        self.translationHistory.insert(historyItem, at: 0)
                    }
                } catch {
                    // Handle any JSON decoding errors
                    self?.errorMessage = "Failed to decode response"
                    print("Debug error: \(error)")
                }
            }
        }.resume()  // Start the network request
    }

    // Function to clear all saved translations
    func clearTranslationHistory() {
        translationHistory.removeAll()
    }
} 