import SwiftUI
import SwiftData
import AppKit

struct ContentView: View {
    let text: String
    @State private var currentIndex = 0
    @Query private var settings: [AppSettings]
    @Environment(\.modelContext) private var modelContext
    
    // textComponentsの変更を監視
    @State private var components: [String] = [NSLocalizedString("How to use: Select text from the Services menu to display as slides.", comment: "Initial instruction text")]
    
    init(text: String) {
        self.text = text
    }
    
    private var appSettings: AppSettings {
        if let existing = settings.first {
            return existing
        }
        let settings = AppSettings()
        modelContext.insert(settings)
        try? modelContext.save()
        return settings
    }
    
    // コンポーネントの更新処理
    private func updateComponents() {
        let sanitizedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 有効な区切り文字を取得
        let enabledDelimiters = appSettings.delimiters
            .filter { $0.isEnabled }
            .map { $0.character }
        
        var newComponents: [String]
        
        if enabledDelimiters.isEmpty {
            // 区切り文字が一つも有効になっていない場合は、テキスト全体を1つのスライドとして扱う
            newComponents = [sanitizedText].filter { !$0.isEmpty }
        } else {
            // すべての有効な区切り文字からCharacterSetを作成
            let delimiterSet = CharacterSet(charactersIn: enabledDelimiters.joined())
            
            // 一度にすべての区切り文字で分割
            newComponents = sanitizedText.components(separatedBy: delimiterSet)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        // 空の場合はデフォルトメッセージを表示
        if newComponents.isEmpty {
            newComponents = [NSLocalizedString("How to use: Select text from the Services menu to display as slides.", comment: "Initial instruction text")]
        }
        
        // コンポーネントを更新
        components = newComponents
        
        // currentIndexが範囲外になっていないかチェック
        if currentIndex >= components.count {
            currentIndex = max(0, components.count - 1)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                appSettings.currentTheme.background
                
                ZStack {
                    SlideTextView(
                        currentText: components.isEmpty ? NSLocalizedString("How to use: Select text from the Services menu to display as slides.", comment: "Initial instruction text") : components[currentIndex],
                        settings: appSettings,
                        geometryWidth: geometry.size.width,
                        geometryHeight: geometry.size.height,
                        onTap: nextSlide
                    )
                    
                    if appSettings.showPageNumber {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(String(format: NSLocalizedString("%d/%d", comment: "Page number format"), currentIndex + 1, components.count))
                                    .font(.system(size: 16))
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 45)
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            currentIndex = 0
            updateComponents()
            NSApp.setActivationPolicy(.regular)
            setupKeyboardHandler()
        }
        .onChange(of: settings) { _, _ in
            updateComponents()
        }
        .onDisappear {
            NSApp.setActivationPolicy(.prohibited)
        }

    }
    
    private func setupKeyboardHandler() {
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            switch event.keyCode {
            case 49, 124: // Space, Right Arrow
                nextSlide()
            case 123: // Left Arrow
                previousSlide()
            case 12: // q
                NSApp.terminate(nil)
            default:
                if let characters = event.characters {
                    if characters.contains("j") {
                        nextSlide()
                    } else if characters.contains("k") {
                        previousSlide()
                    }
                }
            }
            return nil
        }
    }
    
    private func nextSlide() {
        guard currentIndex < components.count - 1 else {
            NSApp.terminate(nil)
            return
        }
        if appSettings.useAnimation {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex += 1
            }
        } else {
            currentIndex += 1
        }
    }
    
    private func previousSlide() {
        guard currentIndex > 0 else { return }
        if appSettings.useAnimation {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex -= 1
            }
        } else {
            currentIndex -= 1
        }
    }
}

// テキスト表示用の補助ビュー
private struct SlideTextView: View {
    let currentText: String
    let settings: AppSettings
    let geometryWidth: CGFloat
    let geometryHeight: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            if settings.autoResizeText {
                Text(currentText)
                    .font(.custom(settings.selectedFont, size: settings.fontSize))
                    .lineSpacing(settings.fontSize * (settings.lineSpacing - 1.0))
                    .frame(width: geometryWidth * settings.textWidth, height: geometryHeight, alignment: .topLeading)
                    .padding(.all, 20)
                    .contentShape(Rectangle())
                    .foregroundColor(settings.currentTheme.foreground)
                    .onTapGesture(perform: onTap)
                    .minimumScaleFactor(0.3) // フォントサイズを最大70%まで縮小
                    .scaledToFit()
            } else {
                Text(currentText)
                    .font(.custom(settings.selectedFont, size: settings.fontSize))
                    .lineSpacing(settings.fontSize * (settings.lineSpacing - 1.0))
                    .frame(width: geometryWidth * settings.textWidth, height: geometryHeight, alignment: .topLeading)
                    .padding(.all, 20)
                    .contentShape(Rectangle())
                    .foregroundColor(settings.currentTheme.foreground)
                    .onTapGesture(perform: onTap)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView(text: "テスト\nテストです。\nこれはテスト,さらにテスト")
        .modelContainer(for: AppSettings.self)
}
