//
//  View+Extensions.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

internal extension View {
    
    func embedInAnyView() -> AnyView {
        AnyView(self)
    }
    
}
