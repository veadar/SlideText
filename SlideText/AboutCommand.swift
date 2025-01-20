import SwiftUI

final class AboutCommand {
    static func showAbout() {
        let alert = NSAlert()
        alert.messageText = "SlideText"
        alert.informativeText = """
        Developer: veadar
        Website: https://oiteiku.netlify.app
        """
        
        _ = alert.addButton(withTitle: NSLocalizedString("Open Website", comment: "About dialog open website button"))
        alert.addButton(withTitle: NSLocalizedString("OK", comment: "About dialog OK button"))
        
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            // Open Websiteボタンがクリックされた
            if let url = URL(string: "https://oiteiku.netlify.app") {
                NSWorkspace.shared.open(url)
            }
        default:
            break
        }
    }
}
