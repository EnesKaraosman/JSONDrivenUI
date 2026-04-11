import XCTest
@testable import JSONDrivenUI

final class JSONExportTests: XCTestCase {

    func testSingleNodeNotWrapped() {
        let json = buildJSONString {
            TextNode("Solo")
        }
        let m = try! JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(m.type, .Text)
        XCTAssertEqual(m.values?.text, "Solo")
    }

    func testMultipleNodesWrappedInVStack() {
        let json = buildJSONString {
            TextNode("A")
            TextNode("B")
            TextNode("C")
        }
        let m = try! JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(m.type, .VStack)
        XCTAssertEqual(m.subviews?.count, 3)
    }

    func testBuildJSONReturnsData() {
        let data = buildJSON {
            TextNode("Test")
        }
        XCTAssertFalse(data.isEmpty)
        // Verify it's valid JSON
        XCTAssertNotNil(try? JSONSerialization.jsonObject(with: data))
    }

    func testBuildJSONStringIsUTF8() {
        let json = buildJSONString {
            TextNode("Unicode: 🎉")
        }
        XCTAssertTrue(json.contains("🎉"))
    }

    func testOutputIsPrettyPrinted() {
        let json = buildJSONString {
            TextNode("Hello")
        }
        // Pretty printed JSON contains newlines and indentation
        XCTAssertTrue(json.contains("\n"))
        XCTAssertTrue(json.contains("  "))
    }

    func testOutputHasSortedKeys() {
        let json = buildJSONString {
            TextNode("Hello", font: "title", fontWeight: "bold")
                .foregroundColor("#FF0000")
                .padding(16)
        }
        // With sorted keys, "font" should come before "fontWeight" and "foregroundColor"
        if let fontRange = json.range(of: "\"font\""),
           let fwRange = json.range(of: "\"fontWeight\"") {
            XCTAssertTrue(fontRange.lowerBound < fwRange.lowerBound)
        }
    }

    func testComplexNestedRoundTrip() {
        let json = buildJSONString {
            NavigationStackNode {
                VStackNode(spacing: 16) {
                    TextNode("Title", font: "largeTitle")
                    ScrollViewNode(axis: "vertical") {
                        HStackNode(spacing: 8) {
                            ImageNode(systemName: "star.fill")
                                .frame(width: 20, height: 20)
                            TextNode("Rating")
                        }
                        ButtonNode("Action", actionId: "btn")
                            .padding(12)
                            .backgroundColor("#007AFF")
                    }
                    ToggleNode("Enabled", isOn: true, actionId: "toggle")
                    TextFieldNode(placeholder: "Search...", actionId: "search")
                    GridNode(spacing: 4) {
                        GridRowNode {
                            RectangleNode()
                            CircleNode()
                        }
                    }
                }
            }
        }

        // Verify round-trip: encode -> decode
        let data = Data(json.utf8)
        let m = try! JSONDecoder().decode(ViewMaterial.self, from: data)
        XCTAssertEqual(m.type, .NavigationStack)
        XCTAssertEqual(m.subviews?.first?.type, .VStack)

        let vstack = m.subviews![0]
        XCTAssertEqual(vstack.subviews?.count, 5)
        XCTAssertEqual(vstack.subviews?[0].type, .Text)
        XCTAssertEqual(vstack.subviews?[1].type, .ScrollView)
        XCTAssertEqual(vstack.subviews?[2].type, .Toggle)
        XCTAssertEqual(vstack.subviews?[3].type, .TextField)
        XCTAssertEqual(vstack.subviews?[4].type, .Grid)
    }

    func testModifiersPreservedInRoundTrip() {
        let json = buildJSONString {
            RectangleNode()
                .frame(width: 100, height: 50)
                .backgroundColor("#FF0000")
                .cornerRadius(12)
                .shadow(radius: 8, color: "#000000", x: 2, y: 4)
                .opacity(0.8)
                .rotation(15)
                .blur(3)
                .grayscale(0.5)
                .border(color: "#0000FF", width: 2)
                .accessibilityLabel("Red box")
        }

        let m = try! JSONDecoder().decode(ViewMaterial.self, from: Data(json.utf8))
        XCTAssertEqual(m.properties?.width, 100)
        XCTAssertEqual(m.properties?.height, 50)
        XCTAssertEqual(m.properties?.backgroundColor, "#FF0000")
        XCTAssertEqual(m.properties?.cornerRadius, 12)
        XCTAssertEqual(m.properties?.shadowRadius, 8)
        XCTAssertEqual(m.properties?.shadowColor, "#000000")
        XCTAssertEqual(m.properties?.shadowX, 2)
        XCTAssertEqual(m.properties?.shadowY, 4)
        XCTAssertEqual(m.properties?.opacity, 0.8)
        XCTAssertEqual(m.properties?.rotation, 15)
        XCTAssertEqual(m.properties?.blur, 3)
        XCTAssertEqual(m.properties?.grayscale, 0.5)
        XCTAssertEqual(m.properties?.borderColor, "#0000FF")
        XCTAssertEqual(m.properties?.borderWidth, 2)
        XCTAssertEqual(m.properties?.accessibilityLabel, "Red box")
    }
}
