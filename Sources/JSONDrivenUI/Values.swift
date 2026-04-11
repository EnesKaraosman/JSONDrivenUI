//
//  Values.swift
//  
//
//  Created by Enes Karaosman on 1.12.2020.
//

import Foundation

public final class Values: Codable, @unchecked Sendable {
    public var text: String?
    public var imageUrl: String?
    public var systemIconName: String?
    public var localImageName: String?

    // Interactive elements
    public var placeholder: String?
    public var actionId: String?
    public var isOn: Bool?

    public init() {}
}
