import AppKit
import SwiftUI
import SwiftData

class ServicesProvider: NSObject {
    static let shared = ServicesProvider()
    private var modelContainer: ModelContainer? = nil
    private var mainWindow: NSWindow?
    
    func setModelContainer(_ container: ModelContainer) {
        self.modelContainer = container
    }
    
    @objc func openSlideText(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard let text = pboard.string(forType: .string),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let container = modelContainer else {
            error.pointee = "Error: could not process text" as NSString
            return
        }
        
        // メインスレッドでウィンドウを生成
        DispatchQueue.main.async { [weak self] in
            // 既存のウィンドウをすべて閉じる
            NSApplication.shared.windows.forEach { $0.close() }
            
            let contentView = ContentView(text: text)
                .modelContainer(container)
            
            let window = NSWindow(
                contentRect: NSScreen.main?.visibleFrame ?? .zero,
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            window.contentView = NSHostingView(rootView: contentView)
            window.collectionBehavior = [.fullScreenPrimary]
            window.center()
            
            // ウィンドウの参照を保持
            self?.mainWindow = window
            
            // アプリをアクティブにしてウィンドウを表示
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
            
            // 少し遅延してフルスクリーンに
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                window.toggleFullScreen(nil)
            }
        }
    }
}
