//
//  ViewProperties.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

public class ViewProperties: Codable {
    var font: String?
    var fontWeight: String?
    var foregroundColor: String?
    var borderColor: String?
    var borderWidth: Int?
    var padding: Int?
    var spacing: Int?
    var width: Float?
    var height: Float?
    var maxWidth: Float?
    var maxHeight: Float?
    var minLength: Float? // Spacer

    /// leading, center, trailing
    var horizontalAlignment: String?

    /// top, bottom, center, firstTextBaseline, lastTextBaseline
    var verticalAlignment: String?

    /// vertical, horizontal (for ScrollView)
    var axis: String?
    var showsIndicators: Bool?

    // Visual modifiers
    var backgroundColor: String?
    var cornerRadius: Float?
    var opacity: Float?
    var shadowRadius: Float?
    var shadowColor: String?
    var shadowX: Float?
    var shadowY: Float?
    var rotation: Float?
    var blur: Float?
    var grayscale: Float?

    /// "circle", "capsule", "rectangle"
    var clipShape: String?

    // Accessibility
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var accessibilityHidden: Bool?

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
