import XCTest
@testable import JSONDrivenUI

final class JSONDrivenUITests: XCTestCase {
    func testJSONDataViewInitWithData() {
        let json = """
        { "type": "Text", "values": { "text": "Hello" } }
        """
        let view = JSONDataView(json: Data(json.utf8))
        XCTAssertEqual(view.json, Data(json.utf8))
    }

    func testJSONDataViewInitWithString() {
        let json = """
        { "type": "Text", "values": { "text": "Hello" } }
        """
        let view = JSONDataView(jsonString: json)
        XCTAssertEqual(view.json, Data(json.utf8))
    }

    func testJSONDataViewActionCallbackIsStored() {
        var called = false
        let view = JSONDataView(jsonString: "{}") { _ in called = true }
        XCTAssertNotNil(view.onAction)
    }
}
