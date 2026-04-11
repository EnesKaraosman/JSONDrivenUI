//
//  ActionHandler.swift
//
//
//  Created by JSONDrivenUI contributors.
//

import Foundation

/// A callback invoked when an interactive element (Button, Toggle, TextField) triggers an action.
///
/// The `String` parameter is the `actionId` defined in the JSON `values`.
public typealias ActionCallback = (String) -> Void
