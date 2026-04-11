import XCTest
import SwiftUI
@testable import JSONDrivenUI

final class ViewPropertiesDecodingTests: XCTestCase {

    func testDefaultsAreNil() throws {
        let json = "{}"
        let props = try JSONDecoder().decode(ViewProperties.self, from: Data(json.utf8))
        XCTAssertNil(props.font)
        XCTAssertNil(props.fontWeight)
        XCTAssertNil(props.foregroundColor)
        XCTAssertNil(props.borderColor)
        XCTAssertNil(props.borderWidth)
        XCTAssertNil(props.padding)
        XCTAssertNil(props.spacing)
        XCTAssertNil(props.backgroundColor)
        XCTAssertNil(props.cornerRadius)
        XCTAssertNil(props.opacity)
        XCTAssertNil(props.rotation)
        XCTAssertNil(props.blur)
        XCTAssertNil(props.grayscale)
    }

    func testFontPickerMapping() {
        XCTAssertEqual(Font.pick["body"], .body)
        XCTAssertEqual(Font.pick["title"], .title)
        XCTAssertEqual(Font.pick["largeTitle"], .largeTitle)
        XCTAssertEqual(Font.pick["headline"], .headline)
        XCTAssertEqual(Font.pick["subheadline"], .subheadline)
        XCTAssertEqual(Font.pick["callout"], .callout)
        XCTAssertEqual(Font.pick["footnote"], .footnote)
        XCTAssertEqual(Font.pick["caption"], .caption)
        XCTAssertNil(Font.pick["invalidFont"])
    }

    func testFontWeightPickerMapping() {
        XCTAssertEqual(Font.Weight.pick["regular"], .regular)
        XCTAssertEqual(Font.Weight.pick["bold"], .bold)
        XCTAssertEqual(Font.Weight.pick["semibold"], .semibold)
        XCTAssertEqual(Font.Weight.pick["heavy"], .heavy)
        XCTAssertEqual(Font.Weight.pick["black"], .black)
        XCTAssertEqual(Font.Weight.pick["light"], .light)
        XCTAssertEqual(Font.Weight.pick["thin"], .thin)
        XCTAssertEqual(Font.Weight.pick["ultraLight"], .ultraLight)
        XCTAssertEqual(Font.Weight.pick["medium"], .medium)
        XCTAssertNil(Font.Weight.pick["invalidWeight"])
    }

    func testAxisPickerMapping() {
        XCTAssertEqual(Axis.Set.pick["vertical"], .vertical)
        XCTAssertEqual(Axis.Set.pick["horizontal"], .horizontal)
        XCTAssertNil(Axis.Set.pick["diagonal"])
    }

    func testHorizontalAlignmentPickerMapping() {
        XCTAssertEqual(HorizontalAlignment.pick["leading"], .leading)
        XCTAssertEqual(HorizontalAlignment.pick["center"], .center)
        XCTAssertEqual(HorizontalAlignment.pick["trailing"], .trailing)
    }

    func testVerticalAlignmentPickerMapping() {
        XCTAssertEqual(VerticalAlignment.pick["top"], .top)
        XCTAssertEqual(VerticalAlignment.pick["center"], .center)
        XCTAssertEqual(VerticalAlignment.pick["bottom"], .bottom)
        XCTAssertEqual(VerticalAlignment.pick["firstTextBaseline"], .firstTextBaseline)
        XCTAssertEqual(VerticalAlignment.pick["lastTextBaseline"], .lastTextBaseline)
    }

    func testOptionalIntToCGFloat() {
        let value: Int? = 16
        XCTAssertEqual(value.toCGFloat(), 16.0)

        let nilValue: Int? = nil
        XCTAssertNil(nilValue.toCGFloat())
    }

    func testOptionalFloatToCGFloat() {
        let value: Float? = 3.5
        XCTAssertEqual(value.toCGFloat(), CGFloat(Float(3.5)))

        let nilValue: Float? = nil
        XCTAssertNil(nilValue.toCGFloat())
    }

    func testOptionalStringToColor() {
        let hex: String? = "#FF0000"
        XCTAssertNotNil(hex.toColor())

        let nilHex: String? = nil
        XCTAssertNil(nilHex.toColor())
    }
}
