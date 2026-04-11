import XCTest
@testable import JSONDrivenUI

final class NodeModifierTests: XCTestCase {

    // MARK: - Previously untested modifiers

    func testMaxFrameModifier() {
        let node = RectangleNode()
            .maxFrame(width: 300, height: 200)
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.maxWidth, 300)
        XCTAssertEqual(m.properties?.maxHeight, 200)
    }

    func testClipShapeCircle() {
        let node = RectangleNode().clipShape("circle")
        XCTAssertEqual(node.toViewMaterial().properties?.clipShape, "circle")
    }

    func testClipShapeCapsule() {
        let node = RectangleNode().clipShape("capsule")
        XCTAssertEqual(node.toViewMaterial().properties?.clipShape, "capsule")
    }

    func testClipShapeRectangle() {
        let node = RectangleNode().clipShape("rectangle")
        XCTAssertEqual(node.toViewMaterial().properties?.clipShape, "rectangle")
    }

    func testRotationModifier() {
        let node = TextNode("Hello").rotation(45)
        XCTAssertEqual(node.toViewMaterial().properties?.rotation, 45)
    }

    func testBlurModifier() {
        let node = TextNode("Hello").blur(5)
        XCTAssertEqual(node.toViewMaterial().properties?.blur, 5)
    }

    func testGrayscaleModifier() {
        let node = ImageNode(systemName: "star").grayscale(0.8)
        XCTAssertEqual(node.toViewMaterial().properties?.grayscale, 0.8)
    }

    func testBorderModifier() {
        let node = RectangleNode().border(color: "#FF0000", width: 2)
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.borderColor, "#FF0000")
        XCTAssertEqual(m.properties?.borderWidth, 2)
    }

    func testFontModifier() {
        let node = TextNode("Hello").font("headline")
        XCTAssertEqual(node.toViewMaterial().properties?.font, "headline")
    }

    func testFontWeightModifier() {
        let node = TextNode("Hello").fontWeight("heavy")
        XCTAssertEqual(node.toViewMaterial().properties?.fontWeight, "heavy")
    }

    // MARK: - Deep chaining

    func testManyModifiersChained() {
        let node = RectangleNode()
            .frame(width: 100, height: 100)
            .maxFrame(width: 200, height: 200)
            .backgroundColor("#FF0000")
            .foregroundColor("#00FF00")
            .cornerRadius(16)
            .clipShape("capsule")
            .opacity(0.9)
            .shadow(radius: 8, color: "#000000", x: 2, y: 4)
            .rotation(30)
            .blur(2)
            .grayscale(0.5)
            .border(color: "#0000FF", width: 1)
            .padding(20)
            .font("title")
            .fontWeight("bold")
            .accessibilityLabel("Test")
            .accessibilityHint("Hint")
            .accessibilityHidden(true)

        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.width, 100)
        XCTAssertEqual(m.properties?.height, 100)
        XCTAssertEqual(m.properties?.maxWidth, 200)
        XCTAssertEqual(m.properties?.maxHeight, 200)
        XCTAssertEqual(m.properties?.backgroundColor, "#FF0000")
        XCTAssertEqual(m.properties?.foregroundColor, "#00FF00")
        XCTAssertEqual(m.properties?.cornerRadius, 16)
        XCTAssertEqual(m.properties?.clipShape, "capsule")
        XCTAssertEqual(m.properties?.opacity, 0.9)
        XCTAssertEqual(m.properties?.shadowRadius, 8)
        XCTAssertEqual(m.properties?.shadowColor, "#000000")
        XCTAssertEqual(m.properties?.shadowX, 2)
        XCTAssertEqual(m.properties?.shadowY, 4)
        XCTAssertEqual(m.properties?.rotation, 30)
        XCTAssertEqual(m.properties?.blur, 2)
        XCTAssertEqual(m.properties?.grayscale, 0.5)
        XCTAssertEqual(m.properties?.borderColor, "#0000FF")
        XCTAssertEqual(m.properties?.borderWidth, 1)
        XCTAssertEqual(m.properties?.padding, 20)
        XCTAssertEqual(m.properties?.font, "title")
        XCTAssertEqual(m.properties?.fontWeight, "bold")
        XCTAssertEqual(m.properties?.accessibilityLabel, "Test")
        XCTAssertEqual(m.properties?.accessibilityHint, "Hint")
        XCTAssertEqual(m.properties?.accessibilityHidden, true)
    }

    // MARK: - Modifier overwriting

    func testLastModifierWins() {
        let node = TextNode("Hello")
            .foregroundColor("#FF0000")
            .foregroundColor("#00FF00") // overwrite
        XCTAssertEqual(node.toViewMaterial().properties?.foregroundColor, "#00FF00")
    }

    // MARK: - Edge cases

    func testZeroPadding() {
        let node = TextNode("Hello").padding(0)
        XCTAssertEqual(node.toViewMaterial().properties?.padding, 0)
    }

    func testNegativeRotation() {
        let node = TextNode("Hello").rotation(-90)
        XCTAssertEqual(node.toViewMaterial().properties?.rotation, -90)
    }

    func testZeroOpacity() {
        let node = TextNode("Hello").opacity(0)
        XCTAssertEqual(node.toViewMaterial().properties?.opacity, 0)
    }

    func testShadowWithOnlyRadius() {
        let node = RectangleNode().shadow(radius: 10)
        let m = node.toViewMaterial()
        XCTAssertEqual(m.properties?.shadowRadius, 10)
        XCTAssertNil(m.properties?.shadowColor)
        XCTAssertNil(m.properties?.shadowX)
        XCTAssertNil(m.properties?.shadowY)
    }
}
