//
//  NodeModifiers.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

extension JSONNode {

    /// Applies padding to all edges.
    public func padding(_ value: Int) -> ModifiedNode {
        ModifiedNode(base: self) { $0.padding = value }
    }

    /// Sets fixed width and/or height.
    public func frame(width: Float? = nil, height: Float? = nil) -> ModifiedNode {
        ModifiedNode(base: self) {
            if let w = width { $0.width = w }
            if let h = height { $0.height = h }
        }
    }

    /// Sets maximum width and/or height.
    public func maxFrame(width: Float? = nil, height: Float? = nil) -> ModifiedNode {
        ModifiedNode(base: self) {
            if let w = width { $0.maxWidth = w }
            if let h = height { $0.maxHeight = h }
        }
    }

    /// Sets the foreground color (hex string like "#FF0000").
    public func foregroundColor(_ hex: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.foregroundColor = hex }
    }

    /// Sets the background color (hex string).
    public func backgroundColor(_ hex: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.backgroundColor = hex }
    }

    /// Rounds the corners.
    public func cornerRadius(_ value: Float) -> ModifiedNode {
        ModifiedNode(base: self) { $0.cornerRadius = value }
    }

    /// Clips to a shape: "circle", "capsule", or "rectangle".
    public func clipShape(_ shape: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.clipShape = shape }
    }

    /// Sets opacity (0.0 to 1.0).
    public func opacity(_ value: Float) -> ModifiedNode {
        ModifiedNode(base: self) { $0.opacity = value }
    }

    /// Adds a shadow.
    public func shadow(radius: Float, color: String? = nil, x: Float? = nil, y: Float? = nil) -> ModifiedNode {
        ModifiedNode(base: self) {
            $0.shadowRadius = radius
            $0.shadowColor = color
            $0.shadowX = x
            $0.shadowY = y
        }
    }

    /// Rotates by degrees.
    public func rotation(_ degrees: Float) -> ModifiedNode {
        ModifiedNode(base: self) { $0.rotation = degrees }
    }

    /// Applies a blur effect.
    public func blur(_ radius: Float) -> ModifiedNode {
        ModifiedNode(base: self) { $0.blur = radius }
    }

    /// Applies a grayscale effect (0.0 to 1.0).
    public func grayscale(_ amount: Float) -> ModifiedNode {
        ModifiedNode(base: self) { $0.grayscale = amount }
    }

    /// Adds a border.
    public func border(color: String, width: Int) -> ModifiedNode {
        ModifiedNode(base: self) {
            $0.borderColor = color
            $0.borderWidth = width
        }
    }

    /// Sets the font.
    public func font(_ font: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.font = font }
    }

    /// Sets the font weight.
    public func fontWeight(_ weight: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.fontWeight = weight }
    }

    /// Sets an accessibility label.
    public func accessibilityLabel(_ label: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.accessibilityLabel = label }
    }

    /// Sets an accessibility hint.
    public func accessibilityHint(_ hint: String) -> ModifiedNode {
        ModifiedNode(base: self) { $0.accessibilityHint = hint }
    }

    /// Hides from accessibility.
    public func accessibilityHidden(_ hidden: Bool = true) -> ModifiedNode {
        ModifiedNode(base: self) { $0.accessibilityHidden = hidden }
    }
}
