//
//  LiveEditorSample.swift
//  Example
//

import SwiftUI
import JSONDrivenUI

struct LiveEditorSampleView: View {
    @State private var jsonText = """
    {
        "type": "VStack",
        "properties": { "spacing": 12, "padding": 16 },
        "subviews": [
            {
                "type": "Text",
                "properties": { "font": "title", "fontWeight": "bold" },
                "values": { "text": "Edit me!" }
            },
            {
                "type": "HStack",
                "properties": { "spacing": 8 },
                "subviews": [
                    {
                        "type": "Circle",
                        "properties": { "width": 40, "height": 40, "foregroundColor": "#FF6B6B" }
                    },
                    {
                        "type": "Circle",
                        "properties": { "width": 40, "height": 40, "foregroundColor": "#4ECDC4" }
                    },
                    {
                        "type": "Circle",
                        "properties": { "width": 40, "height": 40, "foregroundColor": "#45B7D1" }
                    }
                ]
            }
        ]
    }
    """

    @State private var renderedJSON: String = ""
    @State private var lastAction: String = ""
    @State private var isValidJSON: Bool = true
    @State private var debounceTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Live JSON Editor")
                    .font(.headline)
                Spacer()
                Circle()
                    .fill(isValidJSON ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                Text(isValidJSON ? "Valid JSON" : "Invalid JSON")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()

            Divider()

            // Preview
            ScrollView {
                JSONDataView(jsonString: renderedJSON) { actionId in
                    lastAction = actionId
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))

            if !lastAction.isEmpty {
                Text("Last action: \(lastAction)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }

            Divider()

            // Syntax-highlighted editor
            JSONCodeEditor(text: $jsonText)
                .frame(maxHeight: .infinity)
        }
        .onAppear {
            renderedJSON = jsonText
            isValidJSON = validateJSON(jsonText)
        }
        .onChange(of: jsonText) { _, newValue in
            debounceTask?.cancel()
            debounceTask = Task {
                try? await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled else { return }
                let valid = validateJSON(newValue)
                await MainActor.run {
                    isValidJSON = valid
                    if valid {
                        renderedJSON = newValue
                    }
                }
            }
        }
    }

    private func validateJSON(_ text: String) -> Bool {
        guard let data = text.data(using: .utf8), !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return (try? JSONSerialization.jsonObject(with: data)) != nil
    }
}

// MARK: - Platform-specific JSON Code Editor

#if os(macOS)
struct JSONCodeEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView

        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false

        textView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = false
        textView.usesFindBar = true
        textView.textContainerInset = NSSize(width: 8, height: 8)

        textView.delegate = context.coordinator
        textView.string = text
        applyHighlighting(to: textView)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            let selectedRanges = textView.selectedRanges
            textView.string = text
            applyHighlighting(to: textView)
            textView.selectedRanges = selectedRanges
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: JSONCodeEditor

        init(_ parent: JSONCodeEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            parent.applyHighlighting(to: textView)
        }
    }

    func applyHighlighting(to textView: NSTextView) {
        let text = textView.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        let storage = textView.textStorage!

        storage.beginEditing()

        // Reset to default
        storage.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular), range: fullRange)

        let nsText = text as NSString

        // Strings (keys and values)
        highlightStrings(in: nsText, storage: storage)

        // Numbers
        let numberPattern = try! NSRegularExpression(pattern: "(?<=[:,\\[\\s])\\s*(-?\\d+\\.?\\d*(?:[eE][+-]?\\d+)?)")
        for match in numberPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemGreen, range: match.range(at: 1))
        }

        // Booleans and null
        let keywordPattern = try! NSRegularExpression(pattern: "\\b(true|false|null)\\b")
        for match in keywordPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemOrange, range: match.range)
            storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .bold), range: match.range)
        }

        // Braces and brackets
        let bracePattern = try! NSRegularExpression(pattern: "[\\{\\}\\[\\]]")
        for match in bracePattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .semibold), range: match.range)
        }

        storage.endEditing()
    }

    private func highlightStrings(in nsText: NSString, storage: NSMutableAttributedString) {
        let text = nsText as String
        var i = text.startIndex

        while i < text.endIndex {
            guard text[i] == "\"" else {
                i = text.index(after: i)
                continue
            }

            let stringStart = i
            i = text.index(after: i)

            // Walk to closing quote
            var escaped = false
            while i < text.endIndex {
                let c = text[i]
                if escaped {
                    escaped = false
                } else if c == "\\" {
                    escaped = true
                } else if c == "\"" {
                    i = text.index(after: i)
                    break
                }
                i = text.index(after: i)
            }

            let range = NSRange(stringStart..<i, in: text)

            // Check if it's a key (followed by whitespace then colon)
            let rest = text[i...]
            let trimmed = rest.drop(while: { $0 == " " || $0 == "\t" || $0 == "\n" || $0 == "\r" })
            let isKey = trimmed.first == ":"

            let color: NSColor = isKey ? .systemBlue : .systemRed
            storage.addAttribute(.foregroundColor, value: color, range: range)
        }
    }
}

#else
// iOS fallback using plain TextEditor with smart quotes disabled
struct JSONCodeEditor: View {
    @Binding var text: String

    var body: some View {
        TextEditor(text: $text)
            .font(.system(.caption, design: .monospaced))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(8)
    }
}
#endif

#Preview {
    LiveEditorSampleView()
}
