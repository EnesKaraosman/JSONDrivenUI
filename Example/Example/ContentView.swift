//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 19.12.2023.
//

import SwiftUI
import JSONDrivenUI

struct ContentView: View {
    var body: some View {
        JSONDataView(json:  Data(complexSample.utf8))
    }
}

#Preview {
    ContentView()
}
