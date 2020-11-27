//
//  ViewType.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import Foundation

internal enum ViewType: String, Codable {
    case Image     = "Image"
    case Text      = "Text"
    case HStack    = "HStack"
    case VStack    = "VStack"
    case ZStack    = "ZStack"
    case Rectangle = "Rectangle"
    case Circle    = "Circle"
    case Spacer    = "Spacer"
    case Divider   = "Divider"
    case List      = "List"
}
