//
//  AxisBasedStack.swift
//  
//
//  Created by Enes Karaosman on 1.12.2020.
//

import SwiftUI

struct AxisBasedStack<Content: View>: View {
    
    let axis: Axis.Set
    let content: Content
    
    init(axis: Axis.Set, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.content = content()
    }
    
    @ViewBuilder var body: some View {
        if axis == .vertical {
            VStack {
                content
            }
        } else {
            HStack {
                content
            }
        }
    }
    
}
