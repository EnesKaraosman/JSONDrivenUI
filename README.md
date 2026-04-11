# JSONDrivenUI

Convert JSON into native SwiftUI views, or build JSON from a SwiftUI-like DSL.

**Platforms:** iOS 17+ | macOS 14+  
**Swift:** 5.9+

## Installation

Add via Swift Package Manager:

```swift
.package(url: "https://github.com/EnesKaraosman/JSONDrivenUI.git", from: "2.0.0")
```

## Quick Start

```swift
import JSONDrivenUI

// From JSON string
JSONDataView(jsonString: """
    { "type": "Text", "values": { "text": "Hello World" } }
""")

// From Data
JSONDataView(json: myJSONData)

// With action handling
JSONDataView(jsonString: myJSON) { actionId in
    print("Tapped: \(actionId)")
}
```

## Supported View Types

| Type | Description | Key Properties |
|------|-------------|----------------|
| `Text` | Text label | `font`, `fontWeight` |
| `Image` | System, local, or remote image | `systemIconName`, `localImageName`, `imageUrl` |
| `VStack` | Vertical stack | `spacing`, `horizontalAlignment` |
| `HStack` | Horizontal stack | `spacing`, `verticalAlignment` |
| `ZStack` | Depth stack | — |
| `LazyVStack` | Lazy vertical stack | `spacing`, `horizontalAlignment` |
| `LazyHStack` | Lazy horizontal stack | `spacing`, `verticalAlignment` |
| `ScrollView` | Scrollable container | `axis`, `showsIndicators` |
| `List` | List container | — |
| `Grid` | Grid layout | `spacing` |
| `GridRow` | Row inside Grid | — |
| `Button` | Tappable button | `actionId`, `text` |
| `Toggle` | On/off switch | `text`, `isOn`, `actionId` |
| `TextField` | Text input | `placeholder`, `actionId` |
| `NavigationStack` | Navigation container | — |
| `NavigationLink` | Push navigation | `text` (first subview = destination) |
| `Color` | Color fill | `foregroundColor` |
| `Rectangle` | Rectangle shape | — |
| `Circle` | Circle shape | — |
| `Spacer` | Flexible space | `minLength` |
| `Divider` | Line separator | — |

## Supported Properties

| Property | Type | Description |
|----------|------|-------------|
| `font` | String | `largeTitle`, `title`, `headline`, `subheadline`, `body`, `callout`, `footnote`, `caption` |
| `fontWeight` | String | `ultraLight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black` |
| `foregroundColor` | String | Hex color (`#FF0000`) |
| `backgroundColor` | String | Hex color |
| `padding` | Int | Padding on all edges |
| `spacing` | Int | Stack spacing |
| `width` / `height` | Float | Fixed dimensions |
| `maxWidth` / `maxHeight` | Float | Maximum dimensions |
| `cornerRadius` | Float | Corner rounding |
| `clipShape` | String | `circle`, `capsule`, `rectangle` |
| `opacity` | Float | 0.0 to 1.0 |
| `rotation` | Float | Degrees |
| `blur` | Float | Blur radius |
| `grayscale` | Float | 0.0 to 1.0 |
| `shadowRadius` | Float | Shadow blur radius |
| `shadowColor` | String | Hex color |
| `shadowX` / `shadowY` | Float | Shadow offset |
| `borderColor` | String | Hex color |
| `borderWidth` | Int | Border thickness |
| `accessibilityLabel` | String | VoiceOver label |
| `accessibilityHint` | String | VoiceOver hint |
| `accessibilityHidden` | Bool | Hide from VoiceOver |

## Action Handling

Interactive elements (`Button`, `Toggle`, `TextField`) support action callbacks:

```swift
JSONDataView(jsonString: """
{
    "type": "Button",
    "values": { "actionId": "my_button", "text": "Tap Me" }
}
""") { actionId in
    switch actionId {
    case "my_button": print("Button tapped!")
    default: break
    }
}
```

## Builder DSL (SwiftUI-like to JSON)

Build JSON programmatically using a familiar SwiftUI-like syntax:

```swift
import JSONDrivenUI

let json = buildJSONString {
    VStackNode(spacing: 16) {
        TextNode("Hello World", font: "title", fontWeight: "bold")
        HStackNode(spacing: 8) {
            ImageNode(systemName: "star.fill")
                .foregroundColor("#FFD700")
                .frame(width: 24, height: 24)
            TextNode("Favorited")
        }
        ButtonNode("Tap Me", actionId: "my_action")
            .padding(12)
            .backgroundColor("#007AFF")
            .foregroundColor("#FFFFFF")
            .cornerRadius(10)
    }
    .padding(20)
}

// Render the generated JSON
JSONDataView(jsonString: json)
```

Available DSL nodes: `VStackNode`, `HStackNode`, `ZStackNode`, `ScrollViewNode`, `ListNode`, `GridNode`, `GridRowNode`, `TextNode`, `ImageNode`, `ButtonNode`, `ToggleNode`, `TextFieldNode`, `NavigationStackNode`, `NavigationLinkNode`, `SpacerNode`, `DividerNode`, `RectangleNode`, `CircleNode`, `ColorNode`

All modifier methods from the properties table are available as chainable calls (`.padding()`, `.foregroundColor()`, `.cornerRadius()`, `.shadow()`, etc.).

## Error Handling

In debug builds, invalid JSON shows a descriptive error view with the specific decoding issue. In release builds, a generic fallback message is shown.

## Example App

The `Example/` directory contains a multi-tab demo app showcasing:
- Basic text & image layouts
- Grid, Stack, and ScrollView layouts
- Interactive elements (Button, Toggle, TextField)
- Visual styling (shadows, rounded corners, opacity, blur, rotation)
- Navigation with NavigationStack & NavigationLink
- Builder DSL round-trip demo
- Live JSON editor

## Dependencies

- [Kingfisher](https://github.com/onevcat/Kingfisher) — Remote image loading and caching

## License

MIT License. See [LICENSE](LICENSE) for details.
