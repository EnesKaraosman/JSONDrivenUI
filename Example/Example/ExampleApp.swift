//
//  ExampleApp.swift
//  Example
//
//  Created by Enes Karaosman on 19.12.2023.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
    }
}
