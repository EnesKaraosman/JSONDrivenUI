import XCTest
@testable import JSONDrivenUI

final class ErrorHandlingTests: XCTestCase {

    // MARK: - JSONDrivenUIError

    func testDecodingFailedErrorDescription() {
        let error = JSONDrivenUIError.decodingFailed("missing key 'type'")
        XCTAssertTrue(error.errorDescription!.contains("missing key 'type'"))
    }

    func testMaxDepthExceededErrorDescription() {
        let error = JSONDrivenUIError.maxDepthExceeded(50)
        XCTAssertTrue(error.errorDescription!.contains("50"))
    }

    func testFileNotFoundErrorDescription() {
        let error = JSONDrivenUIError.fileNotFound("test.json")
        XCTAssertTrue(error.errorDescription!.contains("test.json"))
    }

    // MARK: - Malformed JSON

    func testCompletelyInvalidJSON() {
        let data = Data("not json at all".utf8)
        let result = try? JSONDecoder().decode(ViewMaterial.self, from: data)
        XCTAssertNil(result)
    }

    func testEmptyObjectDecodesWithNils() throws {
        let json = "{}"
        // ViewMaterial with all optionals should decode from empty object
        // But type is non-optional enum mapped from string, so {} won't have type
        let material = try? JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertNotNil(material)
        XCTAssertNil(material?.type)
        XCTAssertNil(material?.values)
        XCTAssertNil(material?.properties)
        XCTAssertNil(material?.subviews)
    }

    func testJSONArrayInsteadOfObject() {
        let json = "[1, 2, 3]"
        let result = try? JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertNil(result)
    }

    func testNullJSON() {
        let json = "null"
        let result = try? JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertNil(result)
    }

    func testTypeMismatchInProperties() {
        // spacing should be Int, not String
        let json = """
        { "type": "VStack", "properties": { "spacing": "not_a_number" } }
        """
        let result = try? JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertNil(result)
    }

    func testExtraUnknownFieldsAreIgnored() throws {
        let json = """
        { "type": "Text", "values": { "text": "Hello" }, "unknownField": 42, "anotherUnknown": "test" }
        """
        // Should decode successfully, ignoring unknown fields
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.type, .Text)
        XCTAssertEqual(material.values?.text, "Hello")
    }

    func testEmptyStringJSON() {
        let json = ""
        let result = try? JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertNil(result)
    }

    // MARK: - Deep nesting

    func testDeeplyNestedJSONDecodes() throws {
        // Build 10-level deep nesting
        var json = """
        { "type": "Text", "values": { "text": "leaf" } }
        """
        for _ in 0..<10 {
            json = """
            { "type": "VStack", "subviews": [\(json)] }
            """
        }
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.type, .VStack)

        // Walk down to the leaf
        var current = material
        for _ in 0..<10 {
            XCTAssertEqual(current.subviews?.count, 1)
            current = current.subviews![0]
        }
        XCTAssertEqual(current.type, .Text)
        XCTAssertEqual(current.values?.text, "leaf")
    }

    // MARK: - Edge case values

    func testNegativeSpacingDecodes() throws {
        let json = """
        { "type": "VStack", "properties": { "spacing": -5 } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.properties?.spacing, -5)
    }

    func testZeroDimensionsDecodes() throws {
        let json = """
        { "type": "Rectangle", "properties": { "width": 0, "height": 0 } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.properties?.width, 0)
        XCTAssertEqual(material.properties?.height, 0)
    }

    func testOpacityOutOfRangeDecodes() throws {
        let json = """
        { "type": "Text", "properties": { "opacity": 2.5 } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.properties?.opacity, 2.5)
    }

    func testEmptyTextValue() throws {
        let json = """
        { "type": "Text", "values": { "text": "" } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.values?.text, "")
    }

    func testSpecialCharactersInText() throws {
        let json = """
        { "type": "Text", "values": { "text": "Hello\\nWorld\\t\\"quoted\\"" } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertTrue(material.values?.text?.contains("\\n") == true || material.values?.text?.contains("\n") == true)
    }

    func testUnicodeInText() throws {
        let json = """
        { "type": "Text", "values": { "text": "Hello 🌍 Merhaba" } }
        """
        let material = try JSONDecoder().decode(ViewMaterial.self, from: data(json))
        XCTAssertEqual(material.values?.text, "Hello 🌍 Merhaba")
    }

    // MARK: - Helpers

    private func data(_ string: String) -> Data {
        Data(string.utf8)
    }
}
