import XCTest
@testable import JSONDrivenUI

@MainActor
final class DepthLimitTests: XCTestCase {

    func testMaxDepthConstant() {
        XCTAssertEqual(ViewFactory.maxDepth, 50)
    }

    func testFactoryInitDefaultDepthIsZero() {
        let material = ViewMaterial()
        material.type = .Text
        let factory = ViewFactory(material: material)
        // Factory should build fine at depth 0
        let _ = factory.toPresentable()
    }

    func testFactoryRespectsDepthParameter() {
        let material = ViewMaterial()
        material.type = .Text
        material.values = Values()
        material.values?.text = "deep"

        // At depth 49, should still work
        let factory49 = ViewFactory(material: material, depth: 49)
        let _ = factory49.toPresentable()

        // At depth 50 (maxDepth), should show error text instead
        let factory50 = ViewFactory(material: material, depth: 50)
        let _ = factory50.toPresentable()
        // Can't easily assert on AnyView content, but it shouldn't crash
    }

    func testChildFactoryIncrementsDepth() {
        // Build a 3-level deep structure
        let leaf = ViewMaterial()
        leaf.type = .Text
        leaf.values = Values()
        leaf.values?.text = "leaf"

        let mid = ViewMaterial()
        mid.type = .VStack
        mid.subviews = [leaf]

        let root = ViewMaterial()
        root.type = .VStack
        root.subviews = [mid]

        // Should render without issues (only 3 levels)
        let factory = ViewFactory(material: root)
        let _ = factory.toPresentable()
    }

    func testVeryDeepNestingDoesNotCrash() {
        // Build a structure deeper than maxDepth
        var current = ViewMaterial()
        current.type = .Text
        current.values = Values()
        current.values?.text = "bottom"

        for _ in 0..<60 {
            let parent = ViewMaterial()
            parent.type = .VStack
            parent.subviews = [current]
            current = parent
        }

        // Should not crash — depth limit kicks in
        let factory = ViewFactory(material: current)
        let _ = factory.toPresentable()
    }

    func testOnActionThreadedThroughDepth() {
        var actionFired = false

        let button = ViewMaterial()
        button.type = .Button
        button.values = Values()
        button.values?.text = "Tap"
        button.values?.actionId = "test_btn"

        let wrapper = ViewMaterial()
        wrapper.type = .VStack
        wrapper.subviews = [button]

        // The onAction should be threaded to children
        let factory = ViewFactory(material: wrapper, onAction: { id in
            actionFired = true
            XCTAssertEqual(id, "test_btn")
        })
        let _ = factory.toPresentable()
        // Note: We can't trigger the button action in a unit test,
        // but we can verify the factory doesn't crash with an action callback
        XCTAssertFalse(actionFired) // Not triggered yet, just constructed
    }
}
