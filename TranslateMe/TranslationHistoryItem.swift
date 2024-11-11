import Foundation

struct TranslationHistoryItem: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
    let fromLanguage: String
    let toLanguage: String
    let date: Date
} 