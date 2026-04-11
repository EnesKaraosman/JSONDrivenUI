//
//  SwiftUIParserSample.swift
//  Example
//

import SwiftUI
import JSONDrivenUI

struct SwiftUIParserSampleView: View {
    @State private var swiftCode = """
    VStack(spacing: 16) {
        Text("Hello World")
            .font("title")
            .fontWeight("bold")
            .foregroundColor("#007AFF")
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .frame(width: 24, height: 24)
                .foregroundColor("#FFD700")
            Text("SwiftUI to JSON")
                .fontWeight("semibold")
        }
        Button("Tap Me", actionId: "btn1")
            .padding(12)
            .backgroundColor("#007AFF")
            .foregroundColor("#FFFFFF")
            .cornerRadius(10)
    }
    .padding(20)
    """

    @State private var generatedJSON: String = ""
    @State private var parseError: String? = nil
    @State private var debounceTask: Task<Void, Never>?

    var body: some View {
        HSplitView {
            // Left: SwiftUI code editor
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("SwiftUI Code")
                        .font(.headline)
                    Spacer()
                    if parseError != nil {
                        Circle().fill(.red).frame(width: 8, height: 8)
                        Text("Parse Error")
                            .font(.caption)
                            .foregroundStyle(.red)
                    } else if !generatedJSON.isEmpty {
                        Circle().fill(.green).frame(width: 8, height: 8)
                        Text("Parsed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(8)
                Divider()

                SwiftUICodeEditor(text: $swiftCode)

                if let error = parseError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                }
            }

            // Right: JSON output + preview
            VStack(spacing: 0) {
                // Preview
                VStack(alignment: .leading, spacing: 0) {
                    Text("Preview")
                        .font(.headline)
                        .padding(8)
                    Divider()
                    ScrollView {
                        if !generatedJSON.isEmpty {
                            JSONDataView(jsonString: generatedJSON)
                                .padding()
                        } else {
                            Text("Write SwiftUI code to see preview")
                                .foregroundStyle(.secondary)
                                .padding()
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                Divider()

                // JSON output
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Generated JSON")
                            .font(.headline)
                        Spacer()
                        Button("Copy") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(generatedJSON, forType: .string)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .disabled(generatedJSON.isEmpty)
                    }
                    .padding(8)
                    Divider()
                    ScrollView {
                        Text(generatedJSON.isEmpty ? "..." : generatedJSON)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .textSelection(.enabled)
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color.gray.opacity(0.05))
            }
        }
        .onAppear { parseCode() }
        .onChange(of: swiftCode) { _, _ in
            debounceTask?.cancel()
            debounceTask = Task {
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                await MainActor.run { parseCode() }
            }
        }
    }

    private func parseCode() {
        var parser = SwiftUIParser()
        do {
            let node = try parser.parse(swiftCode)
            let material = node.toViewMaterial()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(material)
            generatedJSON = String(data: data, encoding: .utf8) ?? "{}"
            parseError = nil
        } catch let e as SwiftUIParser.ParseError {
            parseError = e.message
        } catch {
            parseError = error.localizedDescription
        }
    }
}

// MARK: - SwiftUI Syntax Parser

struct SwiftUIParser {
    struct ParseError: Error {
        let message: String
    }

    private var source: String = ""
    private var index: String.Index = "".startIndex

    mutating func parse(_ code: String) throws -> JSONNode {
        source = code.trimmingCharacters(in: .whitespacesAndNewlines)
        index = source.startIndex
        let node = try parseView()
        return node
    }

    // MARK: - Tokenizing helpers

    private var isAtEnd: Bool { index >= source.endIndex }
    private var current: Character? { isAtEnd ? nil : source[index] }

    private mutating func advance() { if !isAtEnd { index = source.index(after: index) } }

    private mutating func skipWhitespace() {
        while let c = current, c.isWhitespace { advance() }
    }

    private mutating func peek(_ expected: String) -> Bool {
        let remaining = source[index...]
        return remaining.hasPrefix(expected)
    }

    private mutating func consume(_ expected: String) throws {
        skipWhitespace()
        guard peek(expected) else {
            throw ParseError(message: "Expected '\(expected)' at position \(source.distance(from: source.startIndex, to: index))")
        }
        index = source.index(index, offsetBy: expected.count)
    }

    private mutating func readIdentifier() -> String {
        skipWhitespace()
        var result = ""
        while let c = current, (c.isLetter || c.isNumber || c == "_") {
            result.append(c)
            advance()
        }
        return result
    }

    private mutating func readString() throws -> String {
        try consume("\"")
        var result = ""
        while let c = current, c != "\"" {
            if c == "\\" {
                advance()
                if let escaped = current { result.append(escaped) }
            } else {
                result.append(c)
            }
            advance()
        }
        try consume("\"")
        return result
    }

    private mutating func readNumber() throws -> Double {
        skipWhitespace()
        var numStr = ""
        if current == "-" { numStr.append("-"); advance() }
        while let c = current, c.isNumber || c == "." {
            numStr.append(c)
            advance()
        }
        guard let num = Double(numStr) else {
            throw ParseError(message: "Invalid number: '\(numStr)'")
        }
        return num
    }

    private mutating func readBool() throws -> Bool {
        skipWhitespace()
        if peek("true") { index = source.index(index, offsetBy: 4); return true }
        if peek("false") { index = source.index(index, offsetBy: 5); return false }
        throw ParseError(message: "Expected true or false")
    }

    // MARK: - View parsing

    private mutating func parseView() throws -> JSONNode {
        skipWhitespace()
        let name = readIdentifier()
        guard !name.isEmpty else {
            throw ParseError(message: "Expected view name at position \(source.distance(from: source.startIndex, to: index))")
        }

        // Parse constructor arguments
        let args = try parseArguments()

        // Parse trailing closure (children)
        skipWhitespace()
        var children: [JSONNode]? = nil
        if current == "{" {
            children = try parseChildBlock()
        }

        // Build the node
        var node = try buildNode(name: name, args: args, children: children)

        // Parse chained modifiers
        while true {
            skipWhitespace()
            if current == "." {
                let saved = index
                advance()
                let modName = readIdentifier()
                if modName.isEmpty { index = saved; break }
                skipWhitespace()
                if current == "(" {
                    let modArgs = try parseArguments()
                    node = applyModifier(name: modName, args: modArgs, to: node)
                } else {
                    index = saved
                    break
                }
            } else {
                break
            }
        }

        return node
    }

    private mutating func parseArguments() throws -> [(String?, Any)] {
        skipWhitespace()
        guard current == "(" else { return [] }
        advance() // skip (

        var args: [(String?, Any)] = []
        skipWhitespace()

        while current != ")" && !isAtEnd {
            skipWhitespace()

            // Try to read label: value
            let saved = index
            let label = readIdentifier()
            skipWhitespace()

            if current == ":" && !label.isEmpty {
                advance() // skip :
                skipWhitespace()
                let value = try readValue()
                args.append((label, value))
            } else {
                // Unlabeled argument
                index = saved
                skipWhitespace()
                let value = try readValue()
                args.append((nil, value))
            }

            skipWhitespace()
            if current == "," { advance() }
        }

        try consume(")")
        return args
    }

    private mutating func readValue() throws -> Any {
        skipWhitespace()
        if current == "\"" {
            return try readString()
        } else if current == "-" || (current?.isNumber == true) {
            return try readNumber()
        } else if peek("true") || peek("false") {
            return try readBool()
        } else {
            // Could be an identifier like .leading
            if current == "." { advance() }
            return readIdentifier()
        }
    }

    private mutating func parseChildBlock() throws -> [JSONNode] {
        try consume("{")
        var children: [JSONNode] = []

        while true {
            skipWhitespace()
            if current == "}" || isAtEnd { break }
            let child = try parseView()
            children.append(child)
        }

        try consume("}")
        return children
    }

    // MARK: - Node building

    private func buildNode(name: String, args: [(String?, Any)], children: [JSONNode]?) throws -> JSONNode {
        switch name {
        case "VStack":
            return ContainerBuilder(type: .VStack, args: args, children: children ?? [])
        case "HStack":
            return ContainerBuilder(type: .HStack, args: args, children: children ?? [])
        case "ZStack":
            return ContainerBuilder(type: .ZStack, args: args, children: children ?? [])
        case "ScrollView":
            return ContainerBuilder(type: .ScrollView, args: args, children: children ?? [])
        case "List":
            return ContainerBuilder(type: .List, args: args, children: children ?? [])
        case "LazyVStack":
            return ContainerBuilder(type: .LazyVStack, args: args, children: children ?? [])
        case "LazyHStack":
            return ContainerBuilder(type: .LazyHStack, args: args, children: children ?? [])
        case "NavigationStack":
            return ContainerBuilder(type: .NavigationStack, args: args, children: children ?? [])
        case "Grid":
            return ContainerBuilder(type: .Grid, args: args, children: children ?? [])
        case "GridRow":
            return ContainerBuilder(type: .GridRow, args: args, children: children ?? [])

        case "Text":
            let text = args.first.flatMap { $0.1 as? String } ?? ""
            return TextNode(text)

        case "Image":
            if let sysName = args.first(where: { $0.0 == "systemName" })?.1 as? String {
                return ImageNode(systemName: sysName)
            } else if let url = args.first(where: { $0.0 == "url" })?.1 as? String {
                return ImageNode(url: url)
            } else if let name = args.first?.1 as? String {
                return ImageNode(localName: name)
            }
            return ImageNode(systemName: "photo")

        case "Button":
            let text = args.first(where: { $0.0 == nil })?.1 as? String ?? args.first?.1 as? String ?? "Button"
            let actionId = args.first(where: { $0.0 == "actionId" })?.1 as? String ?? "button"
            if let children = children, !children.isEmpty {
                // Build a ButtonNode manually since we have parsed children
                let m = ViewMaterial()
                m.type = .Button
                m.values = Values()
                m.values?.actionId = actionId
                m.values?.text = text
                m.subviews = children.map { $0.toViewMaterial() }
                return DirectMaterialNode(material: m)
            }
            return ButtonNode(text, actionId: actionId)

        case "Toggle":
            let label = args.first(where: { $0.0 == nil })?.1 as? String ?? ""
            let isOn = args.first(where: { $0.0 == "isOn" })?.1 as? Bool ?? false
            let actionId = args.first(where: { $0.0 == "actionId" })?.1 as? String
            return ToggleNode(label, isOn: isOn, actionId: actionId)

        case "TextField":
            let placeholder = args.first(where: { $0.0 == nil })?.1 as? String ?? "Enter text..."
            let actionId = args.first(where: { $0.0 == "actionId" })?.1 as? String
            return TextFieldNode(placeholder: placeholder, actionId: actionId)

        case "Spacer":
            return SpacerNode()
        case "Divider":
            return DividerNode()
        case "Rectangle":
            return RectangleNode()
        case "Circle":
            return CircleNode()

        case "Color":
            let hex = args.first?.1 as? String ?? "#000000"
            return ColorNode(hex: hex)

        default:
            throw ParseError(message: "Unknown view type: '\(name)'")
        }
    }

    private func applyModifier(name: String, args: [(String?, Any)], to node: JSONNode) -> JSONNode {
        switch name {
        case "font":
            if let v = args.first?.1 as? String { return node.font(v) }
        case "fontWeight":
            if let v = args.first?.1 as? String { return node.fontWeight(v) }
        case "foregroundColor":
            if let v = args.first?.1 as? String { return node.foregroundColor(v) }
        case "backgroundColor":
            if let v = args.first?.1 as? String { return node.backgroundColor(v) }
        case "padding":
            if let v = args.first?.1 as? Double { return node.padding(Int(v)) }
            if args.isEmpty { return node.padding(16) }
        case "frame":
            let w = args.first(where: { $0.0 == "width" })?.1 as? Double
            let h = args.first(where: { $0.0 == "height" })?.1 as? Double
            return node.frame(width: w.map { Float($0) }, height: h.map { Float($0) })
        case "cornerRadius":
            if let v = args.first?.1 as? Double { return node.cornerRadius(Float(v)) }
        case "opacity":
            if let v = args.first?.1 as? Double { return node.opacity(Float(v)) }
        case "blur":
            if let v = args.first?.1 as? Double { return node.blur(Float(v)) }
        case "grayscale":
            if let v = args.first?.1 as? Double { return node.grayscale(Float(v)) }
        case "rotation":
            if let v = args.first?.1 as? Double { return node.rotation(Float(v)) }
        case "shadow":
            let r = args.first(where: { $0.0 == "radius" })?.1 as? Double ?? 5
            let c = args.first(where: { $0.0 == "color" })?.1 as? String
            let x = args.first(where: { $0.0 == "x" })?.1 as? Double
            let y = args.first(where: { $0.0 == "y" })?.1 as? Double
            return node.shadow(radius: Float(r), color: c, x: x.map { Float($0) }, y: y.map { Float($0) })
        case "border":
            let c = args.first(where: { $0.0 == "color" })?.1 as? String ?? args.first?.1 as? String ?? "#000000"
            let w = args.first(where: { $0.0 == "width" })?.1 as? Double ?? 1
            return node.border(color: c, width: Int(w))
        case "clipShape":
            if let v = args.first?.1 as? String { return node.clipShape(v) }
        case "accessibilityLabel":
            if let v = args.first?.1 as? String { return node.accessibilityLabel(v) }
        case "accessibilityHint":
            if let v = args.first?.1 as? String { return node.accessibilityHint(v) }
        case "accessibilityHidden":
            return node.accessibilityHidden(true)
        default:
            break
        }
        return node
    }
}

// MARK: - Helper nodes

private struct DirectMaterialNode: JSONNode {
    let material: ViewMaterial
    func toViewMaterial() -> ViewMaterial { material }
}

private struct ContainerBuilder: JSONNode {
    let type: ViewType
    let args: [(String?, Any)]
    let children: [JSONNode]

    func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = type
        m.subviews = children.map { $0.toViewMaterial() }

        let spacing = args.first(where: { $0.0 == "spacing" })?.1 as? Double
        let hAlign = args.first(where: { $0.0 == "alignment" })?.1 as? String
        let axis = args.first(where: { $0.0 == nil })?.1 as? String

        if spacing != nil || hAlign != nil || axis != nil {
            m.properties = ViewProperties()
            m.properties?.spacing = spacing.map { Int($0) }
            if type == .VStack || type == .LazyVStack {
                m.properties?.horizontalAlignment = hAlign
            } else if type == .HStack || type == .LazyHStack {
                m.properties?.verticalAlignment = hAlign
            }
            if type == .ScrollView {
                m.properties?.axis = axis
            }
        }

        return m
    }
}

// MARK: - SwiftUI Code Editor (macOS NSTextView with syntax highlighting)

#if os(macOS)
struct SwiftUICodeEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView

        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false

        textView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = false
        textView.textContainerInset = NSSize(width: 8, height: 8)

        textView.delegate = context.coordinator
        textView.string = text
        SwiftUIHighlighter.apply(to: textView)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            let ranges = textView.selectedRanges
            textView.string = text
            SwiftUIHighlighter.apply(to: textView)
            textView.selectedRanges = ranges
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: SwiftUICodeEditor
        init(_ parent: SwiftUICodeEditor) { self.parent = parent }

        func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            parent.text = tv.string
            SwiftUIHighlighter.apply(to: tv)
        }
    }
}

enum SwiftUIHighlighter {
    static func apply(to textView: NSTextView) {
        let text = textView.string
        let storage = textView.textStorage!
        let fullRange = NSRange(location: 0, length: (text as NSString).length)

        storage.beginEditing()
        storage.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular), range: fullRange)

        // View type keywords
        let viewTypes = ["VStack", "HStack", "ZStack", "ScrollView", "List", "LazyVStack", "LazyHStack",
                         "NavigationStack", "NavigationLink", "Grid", "GridRow",
                         "Text", "Image", "Button", "Toggle", "TextField",
                         "Spacer", "Divider", "Rectangle", "Circle", "Color"]
        for vt in viewTypes {
            let pattern = try! NSRegularExpression(pattern: "\\b\(vt)\\b")
            for match in pattern.matches(in: text, range: fullRange) {
                storage.addAttribute(.foregroundColor, value: NSColor.systemPurple, range: match.range)
                storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .bold), range: match.range)
            }
        }

        // Strings
        let stringPattern = try! NSRegularExpression(pattern: "\"(?:[^\"\\\\]|\\\\.)*\"")
        for match in stringPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemRed, range: match.range)
        }

        // Numbers
        let numPattern = try! NSRegularExpression(pattern: "(?<=[(:,\\s])-?\\d+\\.?\\d*")
        for match in numPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemGreen, range: match.range)
        }

        // Dot-modifiers
        let modPattern = try! NSRegularExpression(pattern: "\\.([a-zA-Z]+)\\(")
        for match in modPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemTeal, range: match.range(at: 1))
        }

        // Parameter labels
        let labelPattern = try! NSRegularExpression(pattern: "([a-zA-Z]+)\\s*:")
        for match in labelPattern.matches(in: text, range: fullRange) {
            let labelRange = match.range(at: 1)
            // Don't recolor if already a view type
            let labelStr = (text as NSString).substring(with: labelRange)
            if !viewTypes.contains(labelStr) {
                storage.addAttribute(.foregroundColor, value: NSColor.systemBlue, range: labelRange)
            }
        }

        // Booleans
        let boolPattern = try! NSRegularExpression(pattern: "\\b(true|false)\\b")
        for match in boolPattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.foregroundColor, value: NSColor.systemOrange, range: match.range)
            storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .bold), range: match.range)
        }

        // Braces
        let bracePattern = try! NSRegularExpression(pattern: "[\\{\\}\\(\\)]")
        for match in bracePattern.matches(in: text, range: fullRange) {
            storage.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .semibold), range: match.range)
        }

        storage.endEditing()
    }
}
#else
struct SwiftUICodeEditor: View {
    @Binding var text: String
    var body: some View {
        TextEditor(text: $text)
            .font(.system(.caption, design: .monospaced))
            .autocorrectionDisabled()
            .padding(8)
    }
}
#endif

#Preview {
    SwiftUIParserSampleView()
        .frame(width: 900, height: 600)
}
