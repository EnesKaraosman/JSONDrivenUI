//
//  NodeBuilder.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

/// A result builder for composing `JSONNode` hierarchies using a SwiftUI-like DSL.
///
/// ```swift
/// let json = buildJSONString {
///     VStackNode(spacing: 16) {
///         TextNode("Hello", font: "title")
///     }
/// }
/// ```
@resultBuilder
public struct NodeBuilder {
    public static func buildBlock(_ components: JSONNode...) -> [JSONNode] {
        components
    }

    public static func buildBlock(_ components: [JSONNode]...) -> [JSONNode] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [JSONNode]?) -> [JSONNode] {
        component ?? []
    }

    public static func buildEither(first component: [JSONNode]) -> [JSONNode] {
        component
    }

    public static func buildEither(second component: [JSONNode]) -> [JSONNode] {
        component
    }

    public static func buildArray(_ components: [[JSONNode]]) -> [JSONNode] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: JSONNode) -> [JSONNode] {
        [expression]
    }
}
