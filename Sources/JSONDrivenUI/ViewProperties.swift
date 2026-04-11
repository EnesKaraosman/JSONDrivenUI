//
//  ViewProperties.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

public final class ViewProperties: Codable, @unchecked Sendable {
    public var font: String?
    public var fontWeight: String?
    public var foregroundColor: String?
    public var borderColor: String?
    public var borderWidth: Int?
    public var padding: Int?
    public var spacing: Int?
    public var width: Float?
    public var height: Float?
    public var maxWidth: Float?
    public var maxHeight: Float?
    public var minLength: Float?

    /// leading, center, trailing
    public var horizontalAlignment: String?

    /// top, bottom, center, firstTextBaseline, lastTextBaseline
    public var verticalAlignment: String?

    /// vertical, horizontal (for ScrollView)
    public var axis: String?
    public var showsIndicators: Bool?

    // Visual modifiers
    public var backgroundColor: String?
    public var cornerRadius: Float?
    public var opacity: Float?
    public var shadowRadius: Float?
    public var shadowColor: String?
    public var shadowX: Float?
    public var shadowY: Float?
    public var rotation: Float?
    public var blur: Float?
    public var grayscale: Float?

    /// "circle", "capsule", "rectangle"
    public var clipShape: String?

    // Accessibility
    public var accessibilityLabel: String?
    public var accessibilityHint: String?
    public var accessibilityHidden: Bool?

    public init() {}
}

// ScrollView
extension SwiftUI.Axis.Set {
    static let pick: [String : SwiftUI.Axis.Set] = [
        "vertical"   : .vertical,
        "horizontal" : .horizontal
    ]
}

// VStack
extension SwiftUI.HorizontalAlignment {
    static let pick: [String : SwiftUI.HorizontalAlignment] = [
        "leading"  : .leading,
        "center"   : .center,
        "trailing" : .trailing
    ]
}

// HStack
extension SwiftUI.VerticalAlignment {
    static let pick: [String : SwiftUI.VerticalAlignment] = [
        "top"               : .top,
        "center"            : .center,
        "bottom"            : .bottom,
        "firstTextBaseline" : .firstTextBaseline,
        "lastTextBaseline"  : .lastTextBaseline
    ]
}

// Font
extension SwiftUI.Font {
    static let pick: [String : Font] = [
        "largeTitle"  : .largeTitle,
        "title"       : .title,
        "headline"    : .headline,
        "subheadline" : .subheadline,
        "body"        : .body,
        "callout"     : .callout,
        "footnote"    : .footnote,
        "caption"     : .caption
    ]
}

// FontWeight
extension SwiftUI.Font.Weight {
    static let pick: [String : Font.Weight] = [
        "ultraLight" : .ultraLight,
        "thin"       : .thin,
        "light"      : .light,
        "regular"    : .regular,
        "medium"     : .medium,
        "semibold"   : .semibold,
        "bold"       : .bold,
        "heavy"      : .heavy,
        "black"      : .black
    ]
}

extension Optional where Wrapped == Int {
    func toCGFloat() -> CGFloat? {
        guard let nonNil = self else { return nil }
        return CGFloat(nonNil)
    }
}

extension Optional where Wrapped == Float {
    func toCGFloat() -> CGFloat? {
        guard let nonNil = self else { return nil }
        return CGFloat(nonNil)
    }
}

extension Optional where Wrapped == String {
    func toColor() -> Color? {
        guard let nonNil = self else { return nil }
        return Color(hex: nonNil)
    }
}
