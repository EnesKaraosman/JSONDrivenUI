//
//  NodeTypes.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

// MARK: - Container Nodes

/// A vertical stack node.
public struct VStackNode: JSONNode {
    private let alignment: String?
    private let spacing: CGFloat?
    private let children: [JSONNode]

    public init(alignment: String? = nil, spacing: CGFloat? = nil, @NodeBuilder content: () -> [JSONNode]) {
        self.alignment = alignment
        self.spacing = spacing
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .VStack
        m.properties = ViewProperties()
        m.properties?.horizontalAlignment = alignment
        m.properties?.spacing = spacing.flatMap { Int($0) }
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A horizontal stack node.
public struct HStackNode: JSONNode {
    private let alignment: String?
    private let spacing: CGFloat?
    private let children: [JSONNode]

    public init(alignment: String? = nil, spacing: CGFloat? = nil, @NodeBuilder content: () -> [JSONNode]) {
        self.alignment = alignment
        self.spacing = spacing
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .HStack
        m.properties = ViewProperties()
        m.properties?.verticalAlignment = alignment
        m.properties?.spacing = spacing.flatMap { Int($0) }
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A depth stack (overlay) node.
public struct ZStackNode: JSONNode {
    private let children: [JSONNode]

    public init(@NodeBuilder content: () -> [JSONNode]) {
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .ZStack
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A scroll view node.
public struct ScrollViewNode: JSONNode {
    private let axis: String?
    private let showsIndicators: Bool
    private let children: [JSONNode]

    public init(axis: String? = nil, showsIndicators: Bool = true, @NodeBuilder content: () -> [JSONNode]) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .ScrollView
        m.properties = ViewProperties()
        m.properties?.axis = axis
        m.properties?.showsIndicators = showsIndicators
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A list node.
public struct ListNode: JSONNode {
    private let children: [JSONNode]

    public init(@NodeBuilder content: () -> [JSONNode]) {
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .List
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A navigation stack node.
public struct NavigationStackNode: JSONNode {
    private let children: [JSONNode]

    public init(@NodeBuilder content: () -> [JSONNode]) {
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .NavigationStack
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A grid node.
public struct GridNode: JSONNode {
    private let spacing: CGFloat?
    private let children: [JSONNode]

    public init(spacing: CGFloat? = nil, @NodeBuilder content: () -> [JSONNode]) {
        self.spacing = spacing
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Grid
        m.properties = ViewProperties()
        m.properties?.spacing = spacing.flatMap { Int($0) }
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

/// A grid row node.
public struct GridRowNode: JSONNode {
    private let children: [JSONNode]

    public init(@NodeBuilder content: () -> [JSONNode]) {
        self.children = content()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .GridRow
        m.subviews = children.map { $0.toViewMaterial() }
        return m
    }
}

// MARK: - Leaf Nodes

/// A text node.
public struct TextNode: JSONNode {
    private let text: String
    private let font: String?
    private let fontWeight: String?

    public init(_ text: String, font: String? = nil, fontWeight: String? = nil) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Text
        m.values = Values()
        m.values?.text = text
        if font != nil || fontWeight != nil {
            m.properties = ViewProperties()
            m.properties?.font = font
            m.properties?.fontWeight = fontWeight
        }
        return m
    }
}

/// An image node.
public struct ImageNode: JSONNode {
    private let systemName: String?
    private let localName: String?
    private let url: String?

    public init(systemName: String) {
        self.systemName = systemName
        self.localName = nil
        self.url = nil
    }

    public init(localName: String) {
        self.systemName = nil
        self.localName = localName
        self.url = nil
    }

    public init(url: String) {
        self.systemName = nil
        self.localName = nil
        self.url = url
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Image
        m.values = Values()
        m.values?.systemIconName = systemName
        m.values?.localImageName = localName
        m.values?.imageUrl = url
        return m
    }
}

/// A spacer node.
public struct SpacerNode: JSONNode {
    private let minLength: Float?

    public init(minLength: Float? = nil) {
        self.minLength = minLength
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Spacer
        if let minLength {
            m.properties = ViewProperties()
            m.properties?.minLength = minLength
        }
        return m
    }
}

/// A divider node.
public struct DividerNode: JSONNode {
    public init() {}

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Divider
        return m
    }
}

/// A rectangle node.
public struct RectangleNode: JSONNode {
    public init() {}

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Rectangle
        return m
    }
}

/// A circle node.
public struct CircleNode: JSONNode {
    public init() {}

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Circle
        return m
    }
}

/// A color node.
public struct ColorNode: JSONNode {
    private let hex: String

    public init(hex: String) {
        self.hex = hex
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Color
        m.properties = ViewProperties()
        m.properties?.foregroundColor = hex
        return m
    }
}

// MARK: - Interactive Nodes

/// A button node.
public struct ButtonNode: JSONNode {
    private let actionId: String
    private let text: String?
    private let children: [JSONNode]?

    public init(_ text: String, actionId: String) {
        self.text = text
        self.actionId = actionId
        self.children = nil
    }

    public init(actionId: String, @NodeBuilder label: () -> [JSONNode]) {
        self.text = nil
        self.actionId = actionId
        self.children = label()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Button
        m.values = Values()
        m.values?.actionId = actionId
        m.values?.text = text
        m.subviews = children?.map { $0.toViewMaterial() }
        return m
    }
}

/// A toggle node.
public struct ToggleNode: JSONNode {
    private let label: String
    private let isOn: Bool
    private let actionId: String?

    public init(_ label: String, isOn: Bool = false, actionId: String? = nil) {
        self.label = label
        self.isOn = isOn
        self.actionId = actionId
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .Toggle
        m.values = Values()
        m.values?.text = label
        m.values?.isOn = isOn
        m.values?.actionId = actionId
        return m
    }
}

/// A text field node.
public struct TextFieldNode: JSONNode {
    private let placeholder: String
    private let text: String
    private let actionId: String?

    public init(placeholder: String = "Enter text...", text: String = "", actionId: String? = nil) {
        self.placeholder = placeholder
        self.text = text
        self.actionId = actionId
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .TextField
        m.values = Values()
        m.values?.placeholder = placeholder
        m.values?.text = text
        m.values?.actionId = actionId
        return m
    }
}

/// A navigation link node. First child is the destination, rest are the label.
public struct NavigationLinkNode: JSONNode {
    private let text: String?
    private let destination: [JSONNode]?
    private let label: [JSONNode]?

    public init(_ text: String, @NodeBuilder destination: () -> [JSONNode]) {
        self.text = text
        self.destination = destination()
        self.label = nil
    }

    public init(@NodeBuilder destination: () -> [JSONNode], @NodeBuilder label: () -> [JSONNode]) {
        self.text = nil
        self.destination = destination()
        self.label = label()
    }

    public func toViewMaterial() -> ViewMaterial {
        let m = ViewMaterial()
        m.type = .NavigationLink
        m.values = Values()
        m.values?.text = text
        // First subview = destination, rest = label content
        var subs: [ViewMaterial] = []
        if let dest = destination {
            for d in dest { subs.append(d.toViewMaterial()) }
        }
        if let lbl = label {
            for l in lbl { subs.append(l.toViewMaterial()) }
        }
        m.subviews = subs.isEmpty ? nil : subs
        return m
    }
}
