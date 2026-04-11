//
//  PresentableProtocol.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

@MainActor
internal protocol PresentableProtocol {
    associatedtype Content: View

    func toPresentable() -> Content
}
