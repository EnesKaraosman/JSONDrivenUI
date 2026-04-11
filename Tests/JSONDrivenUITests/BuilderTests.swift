import XCTest
@testable import JSONDrivenUI

final class BuilderTests: XCTestCase {

    func testTextNodeProducesCorrectMaterial() {
        let node = TextNode("Hello", font: "title", fontWeight: "bold")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Text)
        XCTAssertEqual(material.values?.text, "Hello")
        XCTAssertEqual(material.properties?.font, "title")
        XCTAssertEqual(material.properties?.fontWeight, "bold")
    }

    func testVStackNodeWithChildren() {
        let node = VStackNode(spacing: 8) {
            TextNode("One")
            TextNode("Two")
        }
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .VStack)
        XCTAssertEqual(material.properties?.spacing, 8)
        XCTAssertEqual(material.subviews?.count, 2)
        XCTAssertEqual(material.subviews?[0].values?.text, "One")
        XCTAssertEqual(material.subviews?[1].values?.text, "Two")
    }

    func testHStackNode() {
        let node = HStackNode(spacing: 4) {
            SpacerNode()
            TextNode("Hello")
            SpacerNode()
        }
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .HStack)
        XCTAssertEqual(material.subviews?.count, 3)
        XCTAssertEqual(material.subviews?[0].type, .Spacer)
        XCTAssertEqual(material.subviews?[1].type, .Text)
    }

    func testImageNodeSystemName() {
        let node = ImageNode(systemName: "star.fill")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Image)
        XCTAssertEqual(material.values?.systemIconName, "star.fill")
    }

    func testImageNodeURL() {
        let node = ImageNode(url: "https://example.com/img.png")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.values?.imageUrl, "https://example.com/img.png")
    }

    func testButtonNode() {
        let node = ButtonNode("Tap", actionId: "btn1")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Button)
        XCTAssertEqual(material.values?.actionId, "btn1")
        XCTAssertEqual(material.values?.text, "Tap")
    }

    func testToggleNode() {
        let node = ToggleNode("Switch", isOn: true, actionId: "toggle1")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Toggle)
        XCTAssertEqual(material.values?.text, "Switch")
        XCTAssertEqual(material.values?.isOn, true)
    }

    func testTextFieldNode() {
        let node = TextFieldNode(placeholder: "Name", actionId: "field1")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .TextField)
        XCTAssertEqual(material.values?.placeholder, "Name")
    }

    func testModifierChaining() {
        let node = TextNode("Hello")
            .padding(16)
            .foregroundColor("#FF0000")
            .backgroundColor("#00FF00")
            .cornerRadius(8)
            .opacity(0.5)

        let material = node.toViewMaterial()
        XCTAssertEqual(material.properties?.padding, 16)
        XCTAssertEqual(material.properties?.foregroundColor, "#FF0000")
        XCTAssertEqual(material.properties?.backgroundColor, "#00FF00")
        XCTAssertEqual(material.properties?.cornerRadius, 8)
        XCTAssertEqual(material.properties?.opacity, 0.5)
    }

    func testShadowModifier() {
        let node = RectangleNode()
            .shadow(radius: 10, color: "#000000", x: 2, y: 4)

        let material = node.toViewMaterial()
        XCTAssertEqual(material.properties?.shadowRadius, 10)
        XCTAssertEqual(material.properties?.shadowColor, "#000000")
        XCTAssertEqual(material.properties?.shadowX, 2)
        XCTAssertEqual(material.properties?.shadowY, 4)
    }

    func testFrameModifier() {
        let node = CircleNode()
            .frame(width: 100, height: 100)

        let material = node.toViewMaterial()
        XCTAssertEqual(material.properties?.width, 100)
        XCTAssertEqual(material.properties?.height, 100)
    }

    func testAccessibilityModifiers() {
        let node = TextNode("Hello")
            .accessibilityLabel("Greeting")
            .accessibilityHint("A greeting")
            .accessibilityHidden(true)

        let material = node.toViewMaterial()
        XCTAssertEqual(material.properties?.accessibilityLabel, "Greeting")
        XCTAssertEqual(material.properties?.accessibilityHint, "A greeting")
        XCTAssertEqual(material.properties?.accessibilityHidden, true)
    }

    func testBuildJSONStringProducesValidJSON() {
        let jsonString = buildJSONString {
            TextNode("Hello")
        }
        XCTAssertFalse(jsonString.isEmpty)

        let data = Data(jsonString.utf8)
        let material = try? JSONDecoder().decode(ViewMaterial.self, from: data)
        XCTAssertNotNil(material)
        XCTAssertEqual(material?.type, .Text)
        XCTAssertEqual(material?.values?.text, "Hello")
    }

    func testBuildJSONRoundTrip() {
        let jsonString = buildJSONString {
            VStackNode(spacing: 16) {
                TextNode("Title", font: "title", fontWeight: "bold")
                HStackNode(spacing: 8) {
                    ImageNode(systemName: "star")
                    TextNode("Subtitle")
                }
            }
        }

        let data = Data(jsonString.utf8)
        let material = try? JSONDecoder().decode(ViewMaterial.self, from: data)
        XCTAssertNotNil(material)
        XCTAssertEqual(material?.type, .VStack)
        XCTAssertEqual(material?.subviews?.count, 2)
        XCTAssertEqual(material?.subviews?[0].type, .Text)
        XCTAssertEqual(material?.subviews?[1].type, .HStack)
        XCTAssertEqual(material?.subviews?[1].subviews?.count, 2)
    }

    func testMultipleRootNodesWrappedInVStack() {
        let jsonString = buildJSONString {
            TextNode("One")
            TextNode("Two")
        }

        let data = Data(jsonString.utf8)
        let material = try? JSONDecoder().decode(ViewMaterial.self, from: data)
        XCTAssertEqual(material?.type, .VStack)
        XCTAssertEqual(material?.subviews?.count, 2)
    }

    func testGridNode() {
        let node = GridNode(spacing: 8) {
            GridRowNode {
                TextNode("A")
                TextNode("B")
            }
        }
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Grid)
        XCTAssertEqual(material.subviews?.count, 1)
        XCTAssertEqual(material.subviews?[0].type, .GridRow)
    }

    func testColorNode() {
        let node = ColorNode(hex: "#FF0000")
        let material = node.toViewMaterial()
        XCTAssertEqual(material.type, .Color)
        XCTAssertEqual(material.properties?.foregroundColor, "#FF0000")
    }

    func testDividerNode() {
        let node = DividerNode()
        XCTAssertEqual(node.toViewMaterial().type, .Divider)
    }
}
