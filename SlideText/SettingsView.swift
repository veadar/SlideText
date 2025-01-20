import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    @State private var availableFonts: [String] = []
    
    private var currentSettings: AppSettings {
        if let existing = settings.first {
            return existing
        }
        let settings = AppSettings()
        modelContext.insert(settings)
        try? modelContext.save()
        return settings
    }

    private func loadAvailableFonts() {
        let fontFamilyNames = NSFontManager.shared.availableFontFamilies
        availableFonts = fontFamilyNames.sorted()
    }
    
    var body: some View {
        Form {
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(NSLocalizedString("Font", comment: "Settings view font label"))
                            .bold()
                        Picker("", selection: Binding(
                            get: { currentSettings.selectedFont },
                            set: { newValue in
                                currentSettings.selectedFont = newValue
                                try? modelContext.save()
                            }
                        )) {
                            ForEach(availableFonts, id: \.self) { font in
                                Text(font)
                                    .tag(font)
                            }
                        }
                        .frame(width: 200)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(NSLocalizedString("Font Size", comment: "Settings view font size label"))
                            .bold()
                        Slider(
                            value: Binding(
                                get: { currentSettings.fontSize },
                                set: { newValue in
                                    currentSettings.fontSize = newValue
                                    try? modelContext.save()
                                }
                            ),
                            in: 24...150,
                            step: 1
                        )
                        .frame(width: 200)
                        Text("\(Int(currentSettings.fontSize))")
                            .monospacedDigit()
                            .frame(width: 40)
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Theme", comment: "Settings view theme label"))
                            .bold()
                        Picker("", selection: Binding(
                            get: { currentSettings.colorTheme },
                            set: { newValue in
                                currentSettings.colorTheme = newValue
                                try? modelContext.save()
                            }
                        )) {
                            ForEach(ColorTheme.allCases, id: \.self) { theme in
                                Text(theme.rawValue)
                                    .tag(theme.rawValue)
                            }
                        }
                        .frame(width: 200)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(NSLocalizedString("Line Spacing", comment: "Settings view line spacing label"))
                            .bold()
                        Slider(
                            value: Binding(
                                get: { currentSettings.lineSpacing },
                                set: { newValue in
                                    currentSettings.lineSpacing = newValue
                                    try? modelContext.save()
                                }
                            ),
                            in: 1.0...3.0,
                            step: 0.1
                        )
                        .frame(width: 200)
                        Text(String(format: "%.1f", currentSettings.lineSpacing))
                            .monospacedDigit()
                            .frame(width: 40)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(NSLocalizedString("Text Width", comment: "Settings view text width label"))
                            .bold()
                        Slider(
                            value: Binding(
                                get: { currentSettings.textWidth },
                                set: { newValue in
                                    currentSettings.textWidth = newValue
                                    try? modelContext.save()
                                }
                            ),
                            in: 0.5...0.95,
                            step: 0.05
                        )
                        .frame(width: 200)
                        Text("\(Int(currentSettings.textWidth * 100))%")
                            .monospacedDigit()
                            .frame(width: 50)
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Animation", comment: "Settings view animation label"))
                            .bold()
                        Toggle(
                            NSLocalizedString("Enable", comment: "Toggle switch enable label"),
                            isOn: Binding(
                                get: { currentSettings.useAnimation },
                                set: { newValue in
                                    currentSettings.useAnimation = newValue
                                    try? modelContext.save()
                                }
                            )
                        )
                        .toggleStyle(.switch)
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Page Number", comment: "Settings view page number label"))
                            .bold()
                        Toggle(
                            "Enable",
                            isOn: Binding(
                                get: { currentSettings.showPageNumber },
                                set: { newValue in
                                    currentSettings.showPageNumber = newValue
                                    try? modelContext.save()
                                }
                            )
                        )
                        .toggleStyle(.switch)
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Auto Resize Text", comment: "Settings view auto resize text label"))
                            .bold()
                        Toggle(
                            NSLocalizedString("Enable", comment: "Toggle switch enable label"),
                            isOn: Binding(
                                get: { currentSettings.autoResizeText },
                                set: { newValue in
                                    currentSettings.autoResizeText = newValue
                                    try? modelContext.save()
                                }
                            )
                        )
                        .toggleStyle(.switch)
                    }
                }
                .padding(8)
            } label: {
                Text(NSLocalizedString("Display Settings", comment: "Settings view display settings group"))
            }
            
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text(NSLocalizedString("Delimiter Settings", comment: "Settings view delimiter settings label"))
                        .bold()
                        .padding(.bottom, 4)
                    
                    Group {
                        Text(NSLocalizedString("Basic", comment: "Settings view basic delimiters group"))
                            .font(.headline)
                        ForEach(0..<5) { index in
                            DelimiterToggleRow(
                                delimiter: currentSettings.delimiters[index],
                                isOn: Binding(
                                    get: { currentSettings.delimiters[index].isEnabled },
                                    set: { newValue in
                                        currentSettings.delimiters[index].isEnabled = newValue
                                        try? modelContext.save()
                                    }
                                )
                            )
                        }
                    }
                    
                    Group {
                        Text(NSLocalizedString("Punctuation", comment: "Settings view punctuation delimiters group"))
                            .font(.headline)
                            .padding(.top, 8)
                        ForEach(5..<14) { index in
                            DelimiterToggleRow(
                                delimiter: currentSettings.delimiters[index],
                                isOn: Binding(
                                    get: { currentSettings.delimiters[index].isEnabled },
                                    set: { newValue in
                                        currentSettings.delimiters[index].isEnabled = newValue
                                        try? modelContext.save()
                                    }
                                )
                            )
                        }
                    }
                    
                    Group {
                        Text(NSLocalizedString("Brackets", comment: "Settings view brackets delimiters group"))
                            .font(.headline)
                            .padding(.top, 8)
                        ForEach(14..<currentSettings.delimiters.count) { index in
                            DelimiterToggleRow(
                                delimiter: currentSettings.delimiters[index],
                                isOn: Binding(
                                    get: { currentSettings.delimiters[index].isEnabled },
                                    set: { newValue in
                                        currentSettings.delimiters[index].isEnabled = newValue
                                        try? modelContext.save()
                                    }
                                )
                            )
                        }
                    }
                }
                .padding(8)
            } label: {
                Text(NSLocalizedString("Text Splitting", comment: "Settings view text splitting group"))
            }
        }
        .formStyle(.grouped)
        .padding()
        .frame(width: 450, height: 650)
        .fixedSize()
        .onAppear {
            loadAvailableFonts()
        }
    }
}

// 区切り文字トグル行の共通コンポーネント
private struct DelimiterToggleRow: View {
    let delimiter: Delimiter
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(delimiter.character == "\n" ? NSLocalizedString("Line Break", comment: "Delimiter line break label") : "「\(delimiter.character)」")
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: AppSettings.self)
}
