import SwiftUI
import SwiftData

@main
struct SlideTextApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var isFirstLaunch = true

    private let modelContainer: ModelContainer = {
        let schema = Schema([AppSettings.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // 初期設定の生成
            let context = container.mainContext
            let descriptor = FetchDescriptor<AppSettings>()
            let existingSettings = try context.fetch(descriptor)
            
            if existingSettings.isEmpty {
                let settings = AppSettings()
                context.insert(settings)
                try context.save()
            }
            
            // ModelContainerをServicesProviderと共有
            ServicesProvider.shared.setModelContainer(container)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if isFirstLaunch {
                    ContentView(text: NSLocalizedString("Space, j/k, →←\nSelect text and choose 'Open in SlideText' from the Services menu\nPress q or reach the last slide to exit\n⌘, to open settings", comment: "Initial welcome message"))
                        .onDisappear {
                            isFirstLaunch = false
                        }
                } else {
                    ContentView(text: "")
                }
            }
            .modelContainer(modelContainer)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)

        #if os(macOS)
        Settings {
            SettingsView()
                .modelContainer(modelContainer)
        }
        .defaultSize(width: 450, height: 180)
        
        WindowGroup("About") {
            EmptyView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("SlideTextについて") {
                    AboutCommand.showAbout()
                }
            }
        }
        #endif
    }
}
