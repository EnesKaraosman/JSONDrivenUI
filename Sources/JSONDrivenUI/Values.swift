//
//  Values.swift
//  
//
//  Created by Enes Karaosman on 1.12.2020.
//

import Foundation

public class Values: Codable {
    var text: String?
    var imageUrl: String?
    var systemIconName: String?
    var localImageName: String?

    // Interactive elements
    var placeholder: String?
    var actionId: String?
    var isOn: Bool?

    public init() {}
}
