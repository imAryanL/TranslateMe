import Foundation

struct Language: Identifiable, Hashable, Equatable {
    let id: UUID
    let code: String
    let name: String
    
    init(code: String, name: String) {
        self.id = UUID()
        self.code = code
        self.name = name
    }
    
    static let supportedLanguages = [
        Language(code: "en", name: "English"),
        Language(code: "it", name: "Italian"),
        Language(code: "es", name: "Spanish"),
        Language(code: "fr", name: "French"),
        Language(code: "de", name: "German"),
        Language(code: "pt", name: "Portuguese"),
        Language(code: "ru", name: "Russian"),
        Language(code: "ja", name: "Japanese"),
        Language(code: "ko", name: "Korean"),
        Language(code: "zh", name: "Chinese"),
        Language(code: "ur", name: "Urdu"),
        Language(code: "hi", name: "Hindi"),
        Language(code: "ar", name: "Arabic"),
        Language(code: "nl", name: "Dutch"),
        Language(code: "pl", name: "Polish"),
        Language(code: "tr", name: "Turkish"),
        Language(code: "vi", name: "Vietnamese"),
        Language(code: "th", name: "Thai"),
        Language(code: "sv", name: "Swedish"),
        Language(code: "da", name: "Danish"),
        Language(code: "fi", name: "Finnish"),
        Language(code: "el", name: "Greek"),
        Language(code: "cs", name: "Czech"),
        Language(code: "ro", name: "Romanian"),
        Language(code: "id", name: "Indonesian"),
        Language(code: "uk", name: "Ukrainian"),
        Language(code: "bn", name: "Bengali"),
        Language(code: "ms", name: "Malay"),
        Language(code: "fa", name: "Persian"),
        Language(code: "sw", name: "Swahili"),
        Language(code: "ta", name: "Tamil"),
        Language(code: "gu", name: "Gujarati")
    ]
} 