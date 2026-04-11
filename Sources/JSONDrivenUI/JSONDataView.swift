//
//  JSONDataView.swift
//
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

/// A SwiftUI view that renders UI from JSON data.
///
/// Use `JSONDataView` to dynamically construct SwiftUI views from JSON.
///
/// ```swift
/// JSONDataView(jsonString: """
///     { "type": "Text", "values": { "text": "Hello" } }
/// """)
/// ```
public struct JSONDataView: View, JSONDataViewProtocol {

    public var json: Data
    public var onAction: ActionCallback?

    /// Creates a view from raw JSON `Data`.
    public init(json: Data) {
        self.json = json
        self.onAction = nil
    }

    /// Creates a view from raw JSON `Data` with an action callback.
    public init(json: Data, onAction: ActionCallback?) {
        self.json = json
        self.onAction = onAction
    }

    /// Creates a view from a JSON string.
    public init(jsonString: String, onAction: ActionCallback? = nil) {
        self.json = Data(jsonString.utf8)
        self.onAction = onAction
    }

    @ViewBuilder public func toPresentable() -> some View {
        let result = decodeJSON()
        switch result {
        case .success(let material):
            ViewFactory(material: material, onAction: onAction).toPresentable()
        case .failure(let error):
            errorView(error)
        }
    }

    public var body: some View {
        toPresentable()
    }

    private func decodeJSON() -> Result<ViewMaterial, JSONDrivenUIError> {
        do {
            let material = try JSONDecoder().decode(ViewMaterial.self, from: json)
            return .success(material)
        } catch let error as DecodingError {
            let detail: String
            switch error {
            case .keyNotFound(let key, let context):
                detail = "Missing key '\(key.stringValue)' at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .typeMismatch(let type, let context):
                detail = "Type mismatch for \(type) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .valueNotFound(let type, let context):
                detail = "Missing value for \(type) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .dataCorrupted(let context):
                detail = "Data corrupted at \(context.codingPath.map(\.stringValue).joined(separator: ".")): \(context.debugDescription)"
            @unknown default:
                detail = error.localizedDescription
            }
            return .failure(.decodingFailed(detail))
        } catch {
            return .failure(.decodingFailed(error.localizedDescription))
        }
    }

    @ViewBuilder private func errorView(_ error: JSONDrivenUIError) -> some View {
        #if DEBUG
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
                .font(.title)
            Text(error.errorDescription ?? "Unknown error")
                .font(.caption)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
        #else
        Text("Failed to load view")
            .foregroundStyle(.secondary)
        #endif
    }
}
