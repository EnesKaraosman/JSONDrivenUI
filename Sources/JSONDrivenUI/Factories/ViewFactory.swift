//
//  ViewFactory.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI
import KingfisherSwiftUI

internal struct ViewFactory: PresentableProtocol {
    
    private let material: ViewMaterial
    
    init(material: ViewMaterial) {
        self.material = material
    }
    
    // MARK: - List
    @ViewBuilder func list() -> some View {
        if let subviews = material.subviews {
            List(subviews) {
                ViewFactory(material: $0).toPresentable()
            }
        } else {
            Text("Please Add Subview")
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
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview")
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
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview")
        }
    }
    
    // MARK: - ZStack
    @ViewBuilder func zstack() -> some View {
        if let subviews = material.subviews {
            ZStack {
                ForEach(subviews) {
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview")
        }
    }
    
    // MARK: - Text
    @ViewBuilder func text() -> some View {
        let fontHashValue = material.properties?.font ?? "body"
        let font = Font.pick[fontHashValue]
        let fontWeightHashValue = material.properties?.fontWeight ?? "regular"
        let fontWeight = Font.Weight.pick[fontWeightHashValue]
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
    
    @ViewBuilder func buildDefault() -> some View {
        switch material.type {
        case .List: list()
        case .VStack: vstack()
        case .HStack: hstack()
        case .ZStack: zstack()
        case .Text: text()
        case .Image: image()
        case .Spacer: spacer()
        case .Rectangle: Rectangle()
        case .Divider: Divider()
        case .Circle: Circle()
        default: EmptyView()
        }
    }
    
    @ViewBuilder func toPresentable() -> some View {
        
        let prop = material.properties

        let uiComponent = buildDefault().embedInAnyView()
        uiComponent
            .modifier(ModifierFactory.PaddingModifier(padding: prop?.padding.toCGFloat()))
            .modifier(ModifierFactory.ForegroundModifier(foregroundColor: prop?.foregroundColor.toColor()))
            .modifier(ModifierFactory.BorderModifier(
                borderColor: prop?.borderColor.toColor(),
                borderWidth: prop?.borderWidth.toCGFloat()
            ))
            .modifier(ModifierFactory.FrameModifier(
                width: prop?.width.toCGFloat(),
                height: prop?.height.toCGFloat()
            ))
        
    }
    
}
