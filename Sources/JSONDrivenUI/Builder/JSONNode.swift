//
//  JSONNode.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

/// A protocol representing a node in a JSON UI tree.
///
/// Conform to this protocol to create custom node types
/// that can be used with the `NodeBuilder` DSL.
public protocol JSONNode {
    /// Converts this node into a `ViewMaterial` for JSON encoding.
    func toViewMaterial() -> ViewMaterial
}

/// A node that wraps another node with additional properties applied.
public struct ModifiedNode: JSONNode {
    let base: JSONNode
    let modify: (ViewProperties) -> Void

    public func toViewMaterial() -> ViewMaterial {
        let material = base.toViewMaterial()
        if material.properties == nil {
            material.properties = ViewProperties()
        }
        modify(material.properties!)
        return material
    }
}
