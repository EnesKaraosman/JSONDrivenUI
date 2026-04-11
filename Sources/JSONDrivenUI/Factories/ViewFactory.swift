//
//  ViewFactory.swift
//
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI
import Kingfisher

@MainActor
internal struct ViewFactory: PresentableProtocol {

    private let material: ViewMaterial
    private let onAction: ActionCallback?
    private let depth: Int

    static let maxDepth = 50

    init(material: ViewMaterial, onAction: ActionCallback? = nil, depth: Int = 0) {
        self.material = material
        self.onAction = onAction
        self.depth = depth
    }

    private func childFactory(material: ViewMaterial) -> ViewFactory {
        ViewFactory(material: material, onAction: onAction, depth: depth + 1)
    }

    // MARK: - ScrollView
    @ViewBuilder func scrollView() -> some View {
        if let subviews = material.subviews {
            let axisKey = material.properties?.axis ?? "vertical"
            let axis = Axis.Set.pick[axisKey] ?? .vertical
            let showsIndicators = material.properties?.showsIndicators ?? true

            ScrollView(axis, showsIndicators: showsIndicators) {
                AxisBasedStack(axis: axis) {
                    ForEach(subviews) { subview in
                        childFactory(material: subview).toPresentable()
                    }
                }
            }
        } else {
            Text("Please Add Subview for ScrollView")
        }
    }

    // MARK: - List
    @ViewBuilder func list() -> some View {
        if let subviews = material.subviews {
            List(subviews) {
                childFactory(material: $0).toPresentable()
            }
        } else {
            Text("Please Add Subview for List")
        }
    }

    // MARK: - VStack
    @ViewBuilder func vstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let horizontalAlignmentKey = material.properties?.horizontalAlignment ?? "center"
            let horizontalAlignment = HorizontalAlignment.pick[horizontalAlignmentKey] ?? .center
            VStack(alignment: horizontalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for VStack")
        }
    }

    // MARK: - LazyVStack
    @ViewBuilder func lazyVstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let horizontalAlignmentKey = material.properties?.horizontalAlignment ?? "center"
            let horizontalAlignment = HorizontalAlignment.pick[horizontalAlignmentKey] ?? .center
            LazyVStack(alignment: horizontalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for LazyVStack")
        }
    }

    // MARK: - HStack
    @ViewBuilder func hstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let verticalAlignmentKey = material.properties?.verticalAlignment ?? "center"
            let verticalAlignment = VerticalAlignment.pick[verticalAlignmentKey] ?? .center
            HStack(alignment: verticalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for HStack")
        }
    }

    // MARK: - LazyHStack
    @ViewBuilder func lazyHstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let verticalAlignmentKey = material.properties?.verticalAlignment ?? "center"
            let verticalAlignment = VerticalAlignment.pick[verticalAlignmentKey] ?? .center
            LazyHStack(alignment: verticalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for LazyHStack")
        }
    }

    // MARK: - ZStack
    @ViewBuilder func zstack() -> some View {
        if let subviews = material.subviews {
            ZStack {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for ZStack")
        }
    }

    // MARK: - Text
    @ViewBuilder func text() -> some View {
        let font = material.properties?.font.flatMap { Font.pick[$0] }
        let fontWeight = material.properties?.fontWeight.flatMap { Font.Weight.pick[$0] }
        Text(material.values?.text ?? "")
            .font(font)
            .fontWeight(fontWeight)
    }

    // MARK: - Image
    @ViewBuilder func image() -> some View {
        if let systemIconName = material.values?.systemIconName {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
        } else if let localIconName = material.values?.localImageName {
            Image(localIconName)
                .resizable()
                .scaledToFit()
        } else if let remoteUrl = material.values?.imageUrl {
            KFImage(URL(string: remoteUrl))
                .resizable()
                .scaledToFit()
        } else {
            Text("Image value could not read")
        }
    }

    // MARK: - Spacer
    @ViewBuilder func spacer() -> some View {
        let minLength = material.properties?.minLength.toCGFloat()
        Spacer(minLength: minLength)
    }

    // MARK: - Button
    @ViewBuilder func button() -> some View {
        if let subviews = material.subviews {
            Button {
                onAction?(material.values?.actionId ?? "button")
            } label: {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Button(material.values?.text ?? "Button") {
                onAction?(material.values?.actionId ?? "button")
            }
        }
    }

    // MARK: - NavigationStack
    @ViewBuilder func navigationStack() -> some View {
        if let subviews = material.subviews {
            NavigationStack {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            NavigationStack {
                EmptyView()
            }
        }
    }

    // MARK: - NavigationLink
    @ViewBuilder func navigationLink() -> some View {
        if let subviews = material.subviews, subviews.count >= 2 {
            NavigationLink {
                childFactory(material: subviews[0]).toPresentable()
            } label: {
                ForEach(Array(subviews.dropFirst())) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            NavigationLink(material.values?.text ?? "Link") {
                if let subviews = material.subviews, let first = subviews.first {
                    childFactory(material: first).toPresentable()
                } else {
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Toggle
    @ViewBuilder func toggle() -> some View {
        ToggleWrapper(
            isOn: material.values?.isOn ?? false,
            label: material.values?.text ?? "",
            onAction: onAction,
            actionId: material.values?.actionId
        )
    }

    // MARK: - TextField
    @ViewBuilder func textField() -> some View {
        TextFieldWrapper(
            text: material.values?.text ?? "",
            placeholder: material.values?.placeholder ?? "Enter text...",
            onAction: onAction,
            actionId: material.values?.actionId
        )
    }

    // MARK: - Color
    @ViewBuilder func colorView() -> some View {
        if let hex = material.properties?.foregroundColor, let color = Color(hex: hex) {
            color
        } else if let hex = material.properties?.backgroundColor, let color = Color(hex: hex) {
            color
        } else {
            SwiftUI.Color.clear
        }
    }

    // MARK: - Grid
    @ViewBuilder func grid() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for Grid")
        }
    }

    // MARK: - GridRow
    @ViewBuilder func gridRow() -> some View {
        if let subviews = material.subviews {
            GridRow {
                ForEach(subviews) {
                    childFactory(material: $0).toPresentable()
                }
            }
        } else {
            EmptyView()
        }
    }

    // MARK: - Build
    @ViewBuilder func buildDefault() -> some View {
        if depth >= Self.maxDepth {
            Text("Max nesting depth exceeded")
                .foregroundStyle(.red)
        } else {
            switch material.type {
            case .ScrollView: scrollView()
            case .List: list()
            case .LazyVStack: lazyVstack()
            case .LazyHStack: lazyHstack()
            case .VStack: vstack()
            case .HStack: hstack()
            case .ZStack: zstack()
            case .Text: text()
            case .Image: image()
            case .Spacer: spacer()
            case .Rectangle: Rectangle()
            case .Divider: Divider()
            case .Circle: Circle()
            case .Button: button()
            case .NavigationStack: navigationStack()
            case .NavigationLink: navigationLink()
            case .Toggle: toggle()
            case .TextField: textField()
            case .Color: colorView()
            case .Grid: grid()
            case .GridRow: gridRow()
            default: EmptyView()
            }
        }
    }

    func toPresentable() -> AnyView {
        let prop = material.properties

        let view = buildDefault()
            .modifier(ModifierFactory.PaddingModifier(padding: prop?.padding.toCGFloat()))
            .modifier(ModifierFactory.ForegroundModifier(foregroundColor: prop?.foregroundColor.toColor()))
            .modifier(ModifierFactory.BackgroundModifier(backgroundColor: prop?.backgroundColor.toColor()))
            .modifier(ModifierFactory.CornerRadiusModifier(cornerRadius: prop?.cornerRadius.toCGFloat()))
            .modifier(ModifierFactory.ClipShapeModifier(clipShape: prop?.clipShape))
            .modifier(ModifierFactory.BorderModifier(
                borderColor: prop?.borderColor.toColor(),
                borderWidth: prop?.borderWidth.toCGFloat()
            ))
            .modifier(ModifierFactory.ShadowModifier(
                color: prop?.shadowColor.toColor(),
                radius: prop?.shadowRadius.toCGFloat(),
                x: prop?.shadowX.toCGFloat(),
                y: prop?.shadowY.toCGFloat()
            ))
            .modifier(ModifierFactory.OpacityModifier(opacity: prop?.opacity.toCGFloat()))
            .modifier(ModifierFactory.RotationModifier(degrees: prop?.rotation.toCGFloat()))
            .modifier(ModifierFactory.BlurModifier(radius: prop?.blur.toCGFloat()))
            .modifier(ModifierFactory.GrayscaleModifier(amount: prop?.grayscale.flatMap { Double($0) }))
            .modifier(ModifierFactory.FrameModifier(
                width: prop?.width.toCGFloat(),
                height: prop?.height.toCGFloat(),
                maxWidth: prop?.maxWidth.toCGFloat(),
                maxHeight: prop?.maxHeight.toCGFloat()
            ))
            .modifier(ModifierFactory.AccessibilityModifier(
                label: prop?.accessibilityLabel,
                hint: prop?.accessibilityHint,
                hidden: prop?.accessibilityHidden
            ))

        return AnyView(view)
    }
}
