//
//  ModifierFactory.swift
//
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

internal struct ModifierFactory {

    struct FrameModifier: ViewModifier {
        var width: CGFloat?
        var height: CGFloat?
        var maxWidth: CGFloat?
        var maxHeight: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            content.frame(
                minWidth: nil,
                idealWidth: nil,
                maxWidth: maxWidth,
                minHeight: nil,
                idealHeight: nil,
                maxHeight: maxHeight
            )
            .frame(width: width, height: height)
        }
    }

    struct ForegroundModifier: ViewModifier {
        var foregroundColor: Color?

        @ViewBuilder func body(content: Content) -> some View {
            if let foregroundColor {
                content.foregroundStyle(foregroundColor)
            } else {
                content
            }
        }
    }

    struct PaddingModifier: ViewModifier {
        var padding: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let padding {
                content.padding(padding)
            } else {
                content
            }
        }
    }

    struct BorderModifier: ViewModifier {
        var borderColor: Color?
        var borderWidth: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let borderWidth, let borderColor {
                content.border(borderColor, width: borderWidth)
            } else {
                content
            }
        }
    }

    struct BackgroundModifier: ViewModifier {
        var backgroundColor: Color?

        @ViewBuilder func body(content: Content) -> some View {
            if let backgroundColor {
                content.background(backgroundColor)
            } else {
                content
            }
        }
    }

    struct CornerRadiusModifier: ViewModifier {
        var cornerRadius: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let cornerRadius {
                content.clipShape(.rect(cornerRadius: cornerRadius))
            } else {
                content
            }
        }
    }

    struct ClipShapeModifier: ViewModifier {
        var clipShape: String?

        @ViewBuilder func body(content: Content) -> some View {
            switch clipShape {
            case "circle":
                content.clipShape(.circle)
            case "capsule":
                content.clipShape(.capsule)
            case "rectangle":
                content.clipShape(.rect)
            default:
                content
            }
        }
    }

    struct OpacityModifier: ViewModifier {
        var opacity: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let opacity {
                content.opacity(opacity)
            } else {
                content
            }
        }
    }

    struct ShadowModifier: ViewModifier {
        var color: Color?
        var radius: CGFloat?
        var x: CGFloat?
        var y: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let radius {
                content.shadow(
                    color: color ?? .black.opacity(0.33),
                    radius: radius,
                    x: x ?? 0,
                    y: y ?? 0
                )
            } else {
                content
            }
        }
    }

    struct RotationModifier: ViewModifier {
        var degrees: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let degrees {
                content.rotationEffect(.degrees(degrees))
            } else {
                content
            }
        }
    }

    struct BlurModifier: ViewModifier {
        var radius: CGFloat?

        @ViewBuilder func body(content: Content) -> some View {
            if let radius {
                content.blur(radius: radius)
            } else {
                content
            }
        }
    }

    struct GrayscaleModifier: ViewModifier {
        var amount: Double?

        @ViewBuilder func body(content: Content) -> some View {
            if let amount {
                content.grayscale(amount)
            } else {
                content
            }
        }
    }

    struct AccessibilityModifier: ViewModifier {
        var label: String?
        var hint: String?
        var hidden: Bool?

        @ViewBuilder func body(content: Content) -> some View {
            content
                .accessibilityLabel(label ?? "")
                .accessibilityHint(hint ?? "")
                .accessibilityHidden(hidden ?? false)
        }
    }
}
