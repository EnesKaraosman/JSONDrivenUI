//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 19.12.2023.
//

import SwiftUI
import JSONDrivenUI

struct ContentView: View {
    @State private var lastAction: String = ""

    var body: some View {
        TabView {
            ScrollView {
                JSONDataView(jsonString: basicSample)
            }
            .tabItem { Label("Basic", systemImage: "text.alignleft") }

            JSONDataView(jsonString: layoutSample)
                .tabItem { Label("Layout", systemImage: "square.grid.2x2") }

            VStack {
                JSONDataView(jsonString: interactiveSample) { actionId in
                    lastAction = actionId
                }
                if !lastAction.isEmpty {
                    Text("Action: \(lastAction)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 4)
                }
            }
            .tabItem { Label("Interactive", systemImage: "hand.tap") }

            JSONDataView(jsonString: stylingSample)
                .tabItem { Label("Styling", systemImage: "paintbrush") }

            JSONDataView(jsonString: navigationSample)
                .tabItem { Label("Navigation", systemImage: "arrow.right.circle") }

            MoreSamplesView()
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
    }
}

struct MoreSamplesView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("SwiftUI to JSON") {
                    SwiftUIParserSampleView()
                }
                NavigationLink("Builder DSL") {
                    BuilderSampleView()
                }
                NavigationLink("Live Editor") {
                    LiveEditorSampleView()
                }
                NavigationLink("Complex (Original)") {
                    ScrollView {
                        JSONDataView(jsonString: complexSample)
                    }
                }
            }
            .navigationTitle("More Samples")
        }
    }
}

#Preview {
    ContentView()
}
