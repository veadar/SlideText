import SwiftUI
import SwiftData

enum ColorTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case sepia = "Sepia"
    case ocean = "Ocean"
    case forest = "Forest"
    case sunset = "Sunset"
    
    var background: Color {
        switch self {
        case .light: return .white
        case .dark: return .black
        case .sepia: return Color(red: 0.98, green: 0.95, blue: 0.87)
        case .ocean: return Color(red: 0.85, green: 0.95, blue: 1.0)
        case .forest: return Color(red: 0.90, green: 0.95, blue: 0.90)
        case .sunset: return Color(red: 1.0, green: 0.95, blue: 0.90)
        }
    }
    
    var foreground: Color {
        switch self {
        case .dark: return .white
        default: return .black
        }
    }
}

struct Delimiter: Hashable, Codable {
    var character: String
    var isEnabled: Bool
    
    init(character: String, isEnabled: Bool = true) {
        self.character = character
        self.isEnabled = isEnabled
    }
}

@Model
final class AppSettings {
    var fontSize: Double
    var colorTheme: String
    var textWidth: Double
    var useAnimation: Bool
    var showPageNumber: Bool
    var delimiters: [Delimiter]
    var selectedFont: String
    var lineSpacing: Double
    var autoResizeText: Bool
    
    init() {
        self.fontSize = 36.0
        self.colorTheme = ColorTheme.light.rawValue
        self.textWidth = 0.7 // テキストの表示幅を70%に設定
        self.useAnimation = true
        self.showPageNumber = true
        self.selectedFont = "Helvetica"
        self.lineSpacing = 1.5 // デフォルトの行間
        self.autoResizeText = true // デフォルトで自動調整を有効に
        self.delimiters = [
            // 基本的な区切り文字
            Delimiter(character: "\n", isEnabled: true),  // デフォルトで有効
            Delimiter(character: "。", isEnabled: true),  // デフォルトで有効
            Delimiter(character: "、", isEnabled: false),
            Delimiter(character: ".", isEnabled: true),   // デフォルトで有効
            Delimiter(character: ",", isEnabled: false),
            
            // 句読点関連
            Delimiter(character: "！", isEnabled: false),
            Delimiter(character: "!", isEnabled: false),
            Delimiter(character: "？", isEnabled: false),
            Delimiter(character: "?", isEnabled: false),
            Delimiter(character: "…", isEnabled: false),
            Delimiter(character: "：", isEnabled: false),
            Delimiter(character: ":", isEnabled: false),
            Delimiter(character: "；", isEnabled: false),
            Delimiter(character: ";", isEnabled: false),
            
            // 括弧関連（閉じ括弧で区切り）
            Delimiter(character: "」", isEnabled: false),
            Delimiter(character: "』", isEnabled: false),
            Delimiter(character: "）", isEnabled: false),
            Delimiter(character: ")", isEnabled: false),
            Delimiter(character: "］", isEnabled: false),
            Delimiter(character: "]", isEnabled: false),
            Delimiter(character: "｝", isEnabled: false),
            Delimiter(character: "}", isEnabled: false)
        ]
    }
    
    var currentTheme: ColorTheme {
        ColorTheme(rawValue: colorTheme) ?? .light
    }
}
