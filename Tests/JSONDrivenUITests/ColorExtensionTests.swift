import XCTest
import SwiftUI
@testable import JSONDrivenUI

final class ColorExtensionTests: XCTestCase {

    func testValidSixCharHex() {
        let color = Color(hex: "#FF0000")
        XCTAssertNotNil(color)
    }

    func testValidSixCharHexWithoutHash() {
        let color = Color(hex: "00FF00")
        XCTAssertNotNil(color)
    }

    func testValidEightCharHex() {
        let color = Color(hex: "#FF000080")
        XCTAssertNotNil(color)
    }

    func testValidTwoCharHex() {
        let color = Color(hex: "AA")
        XCTAssertNotNil(color)
    }

    func testValidFourCharHex() {
        let color = Color(hex: "AA80")
        XCTAssertNotNil(color)
    }

    func testEmptyStringReturnsNil() {
        let color = Color(hex: "")
        XCTAssertNil(color)
    }

    func testHashOnlyReturnsNil() {
        let color = Color(hex: "#")
        XCTAssertNil(color)
    }

    func testVeryLongHexGetsTruncated() {
        // Strings longer than 8 chars get truncated to 8
        let color = Color(hex: "FFAABB00CC")
        XCTAssertNotNil(color)
    }

    func testWhitespaceIsTrimmed() {
        let color = Color(hex: "  #FF0000  ")
        XCTAssertNotNil(color)
    }
}
