//
//  JSONExport.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

/// Builds a JSON `Data` from a `NodeBuilder` DSL closure.
///
/// If the closure produces a single root node, it is encoded directly.
/// If multiple nodes are produced, they are wrapped in a VStack.
///
/// ```swift
/// let data = buildJSON {
///     VStackNode {
///         TextNode("Hello")
///     }
/// }
/// ```
public func buildJSON(@NodeBuilder content: () -> [JSONNode]) -> Data {
    let nodes = content()
    let root: ViewMaterial
    if nodes.count == 1 {
        root = nodes[0].toViewMaterial()
    } else {
        root = ViewMaterial()
        root.type = .VStack
        root.subviews = nodes.map { $0.toViewMaterial() }
    }

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return (try? encoder.encode(root)) ?? Data()
}

/// Builds a JSON string from a `NodeBuilder` DSL closure.
public func buildJSONString(@NodeBuilder content: () -> [JSONNode]) -> String {
    let data = buildJSON(content: content)
    return String(data: data, encoding: .utf8) ?? "{}"
}
