//
//  JSONDrivenUIError.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

/// Errors that can occur when rendering JSON-driven UI.
public enum JSONDrivenUIError: LocalizedError {
    case decodingFailed(String)
    case maxDepthExceeded(Int)
    case fileNotFound(String)

    public var errorDescription: String? {
        switch self {
        case .decodingFailed(let detail):
            return "JSON decoding failed: \(detail)"
        case .maxDepthExceeded(let depth):
            return "Maximum nesting depth (\(depth)) exceeded"
        case .fileNotFound(let name):
            return "JSON file not found: \(name)"
        }
    }
}
