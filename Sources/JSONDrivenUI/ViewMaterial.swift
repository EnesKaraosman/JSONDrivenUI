//
//  ViewMaterial.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import Foundation

public final class ViewMaterial: Codable, Identifiable, @unchecked Sendable {
    public var id = UUID()
    public var type: ViewType?
    public var values: Values?
    public var properties: ViewProperties?
    public var subviews: [ViewMaterial]?

    public init() {}

    public enum CodingKeys: String, CodingKey {
        case type
        case values
        case properties
        case subviews
    }
}
