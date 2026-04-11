# Changelog

All notable changes to JSONDrivenUI will be documented in this file.

## [1.0.0] - 2026-04-11

### Breaking Changes
- Minimum deployment targets raised to **iOS 17.0** / **macOS 14.0**
- Swift tools version bumped to **5.9**
- Kingfisher dependency bumped to **8.0+**
- `ViewProperties` defaults changed from hardcoded values to `nil` (e.g., `foregroundColor` no longer defaults to white)
- `Color.init(hex:)` is now failable (`init?`) — returns `nil` for invalid hex instead of white
- `ViewMaterial`, `ViewProperties`, `Values`, and `ViewType` are now `public`
- Removed `View+Extensions.swift` (`embedInAnyView()` helper)

### Added

#### New View Types
- **Button** — with `actionId` for tap callbacks and optional subview labels
- **Toggle** — on/off switch with `isOn` default state and `actionId`
- **TextField** — text input with `placeholder` and submit callback
- **NavigationStack** — modern navigation container (replaces deprecated NavigationView)
- **NavigationLink** — push navigation with destination/label subviews
- **Color** — solid color fill view
- **Grid** — grid layout container
- **GridRow** — row within a Grid

#### New Modifiers
- `backgroundColor` — background color (hex)
- `cornerRadius` — uses modern `.clipShape(.rect(cornerRadius:))` API
- `clipShape` — clip to `circle`, `capsule`, or `rectangle`
- `opacity` — transparency (0.0–1.0)
- `shadowRadius`, `shadowColor`, `shadowX`, `shadowY` — drop shadow
- `rotation` — rotation in degrees
- `blur` — Gaussian blur
- `grayscale` — desaturation (0.0–1.0)
- `maxWidth`, `maxHeight` — maximum frame dimensions

#### Accessibility
- `accessibilityLabel` — VoiceOver label
- `accessibilityHint` — VoiceOver hint
- `accessibilityHidden` — hide from VoiceOver

#### Action Callback System
- New `ActionCallback` type alias and `onAction` parameter on `JSONDataView`
- Buttons, Toggles, and TextFields fire callbacks with their `actionId`
- Stateful wrappers (`ToggleWrapper`, `TextFieldWrapper`) manage `@State` internally

#### Builder DSL (SwiftUI-like to JSON)
- `@resultBuilder`-based DSL for building JSON programmatically
- Node types: `VStackNode`, `HStackNode`, `ZStackNode`, `TextNode`, `ImageNode`, `ButtonNode`, `ToggleNode`, `TextFieldNode`, `ScrollViewNode`, `ListNode`, `GridNode`, `GridRowNode`, `NavigationStackNode`, `NavigationLinkNode`, `SpacerNode`, `DividerNode`, `RectangleNode`, `CircleNode`, `ColorNode`
- Chainable modifiers: `.padding()`, `.foregroundColor()`, `.backgroundColor()`, `.cornerRadius()`, `.opacity()`, `.shadow()`, `.rotation()`, `.blur()`, `.grayscale()`, `.frame()`, `.maxFrame()`, `.border()`, `.clipShape()`, `.font()`, `.fontWeight()`, `.accessibilityLabel()`, `.accessibilityHint()`, `.accessibilityHidden()`
- `buildJSON()` and `buildJSONString()` top-level functions

#### Error Handling
- `JSONDrivenUIError` enum with `.decodingFailed`, `.maxDepthExceeded`, `.fileNotFound`
- Descriptive error messages in debug builds showing exact decoding failure path
- Generic fallback message in release builds
- Recursion depth limit (max 50 levels) prevents stack overflow

#### Convenience
- `JSONDataView(jsonString:onAction:)` initializer
- `ViewFactory` depth limiting with `maxDepth` constant

#### Example App
- 6-tab multiplatform demo app (iOS + macOS)
- **Basic** — Text, Image, SF Symbols layout
- **Layout** — HStack, VStack, ZStack, Grid, LazyVStack, ScrollView
- **Interactive** — Button, Toggle, TextField with action callbacks
- **Styling** — Shadows, corners, opacity, blur, rotation, grayscale
- **Navigation** — NavigationStack with NavigationLinks
- **More** — SwiftUI-to-JSON editor (syntax highlighted), Live JSON editor (syntax highlighted), Builder DSL round-trip demo

#### Tests
- 160 unit tests across 11 test files
- Coverage: color parsing, JSON decoding, property defaults, builder DSL, node types, node modifiers, JSON export, view factory, error handling, depth limiting

### Fixed
- Copy-paste error in `ViewFactory`: HStack showed "LazyHStack" error message and vice versa
- `ViewProperties` defaults were hardcoded (white foreground, red border) — now `nil`
- `fontWeight` default was `"body"` (invalid weight) — now `nil`
- Example app image URLs changed from `http://` to `https://`

### Improved
- `ViewFactory` annotated with `@MainActor` for Kingfisher 8.x compatibility
- `PresentableProtocol` annotated with `@MainActor`
- Model types marked `final` and `@unchecked Sendable` for Swift 6 readiness
- All model properties made `public` for external consumers
- CI updated to run tests (`swift test -v`) on macOS 15 with Xcode 16
- README rewritten with badges, screenshot gallery, organized property tables, and DSL reference

---

## [1.x] - Previous Releases

See [git history](https://github.com/EnesKaraosman/JSONDrivenUI/commits/main) for changes prior to 1.0.0.
