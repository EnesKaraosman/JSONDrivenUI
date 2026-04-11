import XCTest
@testable import JSONDrivenUI

final class ViewMaterialDecodingTests: XCTestCase {

    func testDecodeSimpleText() throws {
        let json = """
        { "type": "Text", "values": { "text": "Hello" } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .Text)
        XCTAssertEqual(material.values?.text, "Hello")
    }

    func testDecodeVStackWithSubviews() throws {
        let json = """
        {
            "type": "VStack",
            "subviews": [
                { "type": "Text", "values": { "text": "One" } },
                { "type": "Text", "values": { "text": "Two" } }
            ]
        }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .VStack)
        XCTAssertEqual(material.subviews?.count, 2)
        XCTAssertEqual(material.subviews?[0].values?.text, "One")
        XCTAssertEqual(material.subviews?[1].values?.text, "Two")
    }

    func testDecodeWithAllProperties() throws {
        let json = """
        {
            "type": "Text",
            "values": { "text": "Styled" },
            "properties": {
                "font": "title",
                "fontWeight": "bold",
                "foregroundColor": "#FF0000",
                "padding": 16,
                "backgroundColor": "#00FF00",
                "cornerRadius": 8.0,
                "opacity": 0.5,
                "rotation": 45.0
            }
        }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.properties?.font, "title")
        XCTAssertEqual(material.properties?.fontWeight, "bold")
        XCTAssertEqual(material.properties?.foregroundColor, "#FF0000")
        XCTAssertEqual(material.properties?.padding, 16)
        XCTAssertEqual(material.properties?.backgroundColor, "#00FF00")
        XCTAssertEqual(material.properties?.cornerRadius, 8.0)
        XCTAssertEqual(material.properties?.opacity, 0.5)
        XCTAssertEqual(material.properties?.rotation, 45.0)
    }

    func testDecodeWithMissingOptionalFields() throws {
        let json = """
        { "type": "Spacer" }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .Spacer)
        XCTAssertNil(material.values)
        XCTAssertNil(material.properties)
        XCTAssertNil(material.subviews)
    }

    func testDecodeInvalidTypeThrows() {
        let json = """
        { "type": "NonExistentView" }
        """
        XCTAssertThrowsError(try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8)))
    }

    func testDecodeButton() throws {
        let json = """
        {
            "type": "Button",
            "values": { "text": "Tap", "actionId": "btn1" },
            "subviews": [
                { "type": "Text", "values": { "text": "Label" } }
            ]
        }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .Button)
        XCTAssertEqual(material.values?.actionId, "btn1")
        XCTAssertEqual(material.subviews?.count, 1)
    }

    func testDecodeToggle() throws {
        let json = """
        { "type": "Toggle", "values": { "text": "Enabled", "isOn": true } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .Toggle)
        XCTAssertEqual(material.values?.isOn, true)
    }

    func testDecodeTextField() throws {
        let json = """
        { "type": "TextField", "values": { "placeholder": "Name...", "actionId": "name" } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.type, .TextField)
        XCTAssertEqual(material.values?.placeholder, "Name...")
    }

    func testDecodeAccessibilityProperties() throws {
        let json = """
        {
            "type": "Text",
            "values": { "text": "Hello" },
            "properties": {
                "accessibilityLabel": "Greeting",
                "accessibilityHint": "A greeting message",
                "accessibilityHidden": false
            }
        }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(material.properties?.accessibilityLabel, "Greeting")
        XCTAssertEqual(material.properties?.accessibilityHint, "A greeting message")
        XCTAssertEqual(material.properties?.accessibilityHidden, false)
    }

    func testEncodeDecodeRoundTrip() throws {
        let original = ViewMaterial()
        original.type = .HStack
        original.properties = ViewProperties()
        original.properties?.spacing = 8
        original.values = Values()
        original.values?.text = "test"

        let child = ViewMaterial()
        child.type = .Text
        child.values = Values()
        child.values?.text = "child"
        original.subviews = [child]

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ViewMaterial.self, from: data)

        XCTAssertEqual(decoded.type, .HStack)
        XCTAssertEqual(decoded.properties?.spacing, 8)
        XCTAssertEqual(decoded.subviews?.count, 1)
        XCTAssertEqual(decoded.subviews?[0].values?.text, "child")
    }
}
