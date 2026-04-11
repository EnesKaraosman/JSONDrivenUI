import XCTest
@testable import JSONDrivenUI

final class NodeTypeTests: XCTestCase {

    // MARK: - Container nodes

    func testZStackNode() {
        let node = ZStackNode {
            RectangleNode()
            CircleNode()
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .ZStack)
        XCTAssertEqual(m.subviews?.count, 2)
        XCTAssertEqual(m.subviews?[0].type, .Rectangle)
        XCTAssertEqual(m.subviews?[1].type, .Circle)
    }

    func testScrollViewNode() {
        let node = ScrollViewNode(axis: "horizontal", showsIndicators: false) {
            TextNode("A")
            TextNode("B")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .ScrollView)
        XCTAssertEqual(m.properties?.axis, "horizontal")
        XCTAssertEqual(m.properties?.showsIndicators, false)
        XCTAssertEqual(m.subviews?.count, 2)
    }

    func testScrollViewDefaultIndicators() {
        let node = ScrollViewNode { TextNode("A") }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.showsIndicators, true)
    }

    func testListNode() {
        let node = ListNode {
            TextNode("Item 1")
            TextNode("Item 2")
            TextNode("Item 3")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .List)
        XCTAssertEqual(m.subviews?.count, 3)
    }

    func testNavigationStackNode() {
        let node = NavigationStackNode {
            TextNode("Content")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .NavigationStack)
        XCTAssertEqual(m.subviews?.count, 1)
    }

    func testVStackAlignment() {
        let node = VStackNode(alignment: "leading", spacing: 4) {
            TextNode("A")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.horizontalAlignment, "leading")
        XCTAssertEqual(m.properties?.spacing, 4)
    }

    func testHStackAlignment() {
        let node = HStackNode(alignment: "top", spacing: 12) {
            TextNode("A")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.verticalAlignment, "top")
        XCTAssertEqual(m.properties?.spacing, 12)
    }

    func testSingleChildContainer() {
        let node = VStackNode {
            SpacerNode()
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .VStack)
        XCTAssertEqual(m.subviews?.count, 1)
    }

    // MARK: - Leaf nodes

    func testTextNodeWithNoFont() {
        let node = TextNode("Hello")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Text)
        XCTAssertEqual(m.values?.text, "Hello")
        XCTAssertNil(m.properties) // No font set, no properties created
    }

    func testTextNodeWithFont() {
        let node = TextNode("Hello", font: "headline")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.font, "headline")
        XCTAssertNil(m.properties?.fontWeight)
    }

    func testTextNodeWithBothFontAndWeight() {
        let node = TextNode("Hello", font: "title", fontWeight: "bold")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.font, "title")
        XCTAssertEqual(m.properties?.fontWeight, "bold")
    }

    func testTextNodeEmptyString() {
        let node = TextNode("")
        XCTAssertEqual(node.toViewMaterial().values?.text, "")
    }

    func testImageNodeLocalName() {
        let node = ImageNode(localName: "myImage")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Image)
        XCTAssertEqual(m.values?.localImageName, "myImage")
        XCTAssertNil(m.values?.systemIconName)
        XCTAssertNil(m.values?.imageUrl)
    }

    func testSpacerNodeDefault() {
        let node = SpacerNode()
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Spacer)
        XCTAssertNil(m.properties)
    }

    func testSpacerNodeWithMinLength() {
        let node = SpacerNode(minLength: 20)
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.minLength, 20)
    }

    func testRectangleNode() {
        let m = RectangleNode().toViewMaterial()
        XCTAssertEqual(m.type, .Rectangle)
        XCTAssertNil(m.values)
        XCTAssertNil(m.properties)
        XCTAssertNil(m.subviews)
    }

    func testCircleNode() {
        XCTAssertEqual(CircleNode().toViewMaterial().type, .Circle)
    }

    // MARK: - Interactive nodes

    func testButtonNodeWithText() {
        let node = ButtonNode("Press", actionId: "press_btn")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Button)
        XCTAssertEqual(m.values?.text, "Press")
        XCTAssertEqual(m.values?.actionId, "press_btn")
        XCTAssertNil(m.subviews)
    }

    func testButtonNodeWithChildren() {
        let node = ButtonNode(actionId: "custom") {
            HStackNode(spacing: 4) {
                ImageNode(systemName: "star")
                TextNode("Star")
            }
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Button)
        XCTAssertEqual(m.values?.actionId, "custom")
        XCTAssertNil(m.values?.text)
        XCTAssertEqual(m.subviews?.count, 1)
        XCTAssertEqual(m.subviews?[0].type, .HStack)
    }

    func testToggleNodeDefaults() {
        let node = ToggleNode("Switch")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Toggle)
        XCTAssertEqual(m.values?.text, "Switch")
        XCTAssertEqual(m.values?.isOn, false)
        XCTAssertNil(m.values?.actionId)
    }

    func testToggleNodeFullParams() {
        let node = ToggleNode("WiFi", isOn: true, actionId: "wifi")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.values?.isOn, true)
        XCTAssertEqual(m.values?.actionId, "wifi")
    }

    func testTextFieldNodeDefaults() {
        let node = TextFieldNode()
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .TextField)
        XCTAssertEqual(m.values?.placeholder, "Enter text...")
        XCTAssertEqual(m.values?.text, "")
        XCTAssertNil(m.values?.actionId)
    }

    func testTextFieldNodeFullParams() {
        let node = TextFieldNode(placeholder: "Name", text: "John", actionId: "name_field")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.values?.placeholder, "Name")
        XCTAssertEqual(m.values?.text, "John")
        XCTAssertEqual(m.values?.actionId, "name_field")
    }

    func testNavigationLinkNodeWithText() {
        let node = NavigationLinkNode("Details") {
            TextNode("Detail Content")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .NavigationLink)
        XCTAssertEqual(m.values?.text, "Details")
        XCTAssertEqual(m.subviews?.count, 1)
    }

    func testNavigationLinkNodeWithDestinationAndLabel() {
        let node = NavigationLinkNode {
            TextNode("Destination")
        } label: {
            TextNode("Go")
        }
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .NavigationLink)
        XCTAssertNil(m.values?.text)
        XCTAssertEqual(m.subviews?.count, 2)
    }

    func testColorNode() {
        let node = ColorNode(hex: "#AABBCC")
        let m = node.toViewMaterial()
        XCTAssertEqual(m.type, .Color)
        XCTAssertEqual(m.properties?.foregroundColor, "#AABBCC")
    }
}
