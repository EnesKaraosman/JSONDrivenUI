//
//  BuilderSample.swift
//  Example
//

import SwiftUI
import JSONDrivenUI

struct BuilderSampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Builder DSL Round-Trip")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text("The JSON below was generated from Swift code using the Builder DSL, then rendered back as a SwiftUI view.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                let jsonString = buildJSONString {
                    VStackNode(spacing: 16) {
                        TextNode("Built from DSL", font: "title", fontWeight: "bold")
                            .foregroundColor("#007AFF")

                        HStackNode(spacing: 12) {
                            ImageNode(systemName: "hammer.fill")
                                .foregroundColor("#FF6B6B")
                                .frame(width: 30, height: 30)
                            TextNode("This view was built in Swift code")
                        }

                        HStackNode(spacing: 8) {
                            RectangleNode()
                                .foregroundColor("#4ECDC4")
                                .cornerRadius(8)
                                .frame(width: 50, height: 50)
                            RectangleNode()
                                .foregroundColor("#FFD93D")
                                .cornerRadius(8)
                                .frame(width: 50, height: 50)
                            RectangleNode()
                                .foregroundColor("#FF6B6B")
                                .cornerRadius(8)
                                .frame(width: 50, height: 50)
                        }

                        ButtonNode("Tap Me", actionId: "dsl_button")
                            .foregroundColor("#FFFFFF")
                            .backgroundColor("#007AFF")
                            .cornerRadius(10)
                            .padding(12)
                    }
                    .padding(20)
                }

                JSONDataView(jsonString: jsonString) { actionId in
                    print("Action: \(actionId)")
                }

                Divider()
                    .padding(.horizontal)

                Text("Generated JSON:")
                    .font(.headline)
                    .padding(.horizontal)

                Text(jsonString)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    BuilderSampleView()
}
