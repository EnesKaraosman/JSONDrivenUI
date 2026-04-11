//
//  StatefulViews.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import SwiftUI

internal struct ToggleWrapper: View {
    @State private var isOn: Bool
    let label: String
    let onAction: ActionCallback?
    let actionId: String?

    init(isOn: Bool, label: String, onAction: ActionCallback?, actionId: String?) {
        self._isOn = State(initialValue: isOn)
        self.label = label
        self.onAction = onAction
        self.actionId = actionId
    }

    var body: some View {
        Toggle(label, isOn: $isOn)
            .onChange(of: isOn) { _, newValue in
                onAction?(actionId ?? "toggle")
            }
    }
}

internal struct TextFieldWrapper: View {
    @State private var text: String
    let placeholder: String
    let onAction: ActionCallback?
    let actionId: String?

    init(text: String, placeholder: String, onAction: ActionCallback?, actionId: String?) {
        self._text = State(initialValue: text)
        self.placeholder = placeholder
        self.onAction = onAction
        self.actionId = actionId
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .onSubmit {
                onAction?(actionId ?? "textfield")
            }
    }
}
