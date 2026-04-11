//
//  ViewType.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import Foundation

public enum ViewType: String, Codable {
    case Image           = "Image"
    case Text            = "Text"
    case LazyHStack      = "LazyHStack"
    case LazyVStack      = "LazyVStack"
    case HStack          = "HStack"
    case VStack          = "VStack"
    case ZStack          = "ZStack"
    case Rectangle       = "Rectangle"
    case Circle          = "Circle"
    case Spacer          = "Spacer"
    case Divider         = "Divider"
    case List            = "List"
    case ScrollView      = "ScrollView"
    case Button          = "Button"
    case NavigationStack = "NavigationStack"
    case NavigationLink  = "NavigationLink"
    case Toggle          = "Toggle"
    case TextField       = "TextField"
    case Color           = "Color"
    case Grid            = "Grid"
    case GridRow         = "GridRow"
}
