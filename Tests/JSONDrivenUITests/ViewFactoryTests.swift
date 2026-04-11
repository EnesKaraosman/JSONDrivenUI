import XCTest
import SwiftUI
@testable import JSONDrivenUI

@MainActor
final class ViewFactoryTests: XCTestCase {

    // MARK: - Factory construction

    func testFactoryDefaultOnActionIsNil() {
        let m = material(.Text)
        let factory = ViewFactory(material: m)
        // Should not crash when building without onAction
        let _ = factory.toPresentable()
    }

    func testFactoryWithOnAction() {
        let m = material(.Text)
        let factory = ViewFactory(material: m, onAction: { _ in })
        let _ = factory.toPresentable()
    }

    // MARK: - All view types produce views without crashing

    func testTextViewBuilds() {
        let m = material(.Text)
        m.values = Values()
        m.values?.text = "Hello"
        m.properties = ViewProperties()
        m.properties?.font = "title"
        m.properties?.fontWeight = "bold"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testTextViewNilFontWeight() {
        let m = material(.Text)
        m.values = Values()
        m.values?.text = "Test"
        // No properties at all — font and weight should be nil
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testImageSystemName() {
        let m = material(.Image)
        m.values = Values()
        m.values?.systemIconName = "star.fill"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testImageLocalName() {
        let m = material(.Image)
        m.values = Values()
        m.values?.localImageName = "testImage"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testImageRemoteURL() {
        let m = material(.Image)
        m.values = Values()
        m.values?.imageUrl = "https://example.com/img.png"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testImageNoValue() {
        let m = material(.Image)
        m.values = Values() // no icon, no url
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testSpacerDefault() {
        let m = material(.Spacer)
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testSpacerWithMinLength() {
        let m = material(.Spacer)
        m.properties = ViewProperties()
        m.properties?.minLength = 20
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testRectangleBuilds() {
        let _ = ViewFactory(material: material(.Rectangle)).toPresentable()
    }

    func testCircleBuilds() {
        let _ = ViewFactory(material: material(.Circle)).toPresentable()
    }

    func testDividerBuilds() {
        let _ = ViewFactory(material: material(.Divider)).toPresentable()
    }

    // MARK: - Container views

    func testVStackWithSubviews() {
        let m = material(.VStack)
        m.properties = ViewProperties()
        m.properties?.spacing = 8
        m.properties?.horizontalAlignment = "leading"
        m.subviews = [material(.Text), material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testVStackNoSubviews() {
        let m = material(.VStack)
        // No subviews — should show fallback text
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testHStackWithAlignment() {
        let m = material(.HStack)
        m.properties = ViewProperties()
        m.properties?.spacing = 4
        m.properties?.verticalAlignment = "top"
        m.subviews = [material(.Spacer)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testZStackWithSubviews() {
        let m = material(.ZStack)
        m.subviews = [material(.Circle), material(.Rectangle)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testLazyVStackBuilds() {
        let m = material(.LazyVStack)
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testLazyHStackBuilds() {
        let m = material(.LazyHStack)
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testScrollViewVertical() {
        let m = material(.ScrollView)
        m.properties = ViewProperties()
        m.properties?.axis = "vertical"
        m.properties?.showsIndicators = false
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testScrollViewHorizontal() {
        let m = material(.ScrollView)
        m.properties = ViewProperties()
        m.properties?.axis = "horizontal"
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testScrollViewDefaultAxis() {
        let m = material(.ScrollView)
        m.subviews = [material(.Text)]
        // No axis property — defaults to vertical
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testListBuilds() {
        let m = material(.List)
        m.subviews = [material(.Text), material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testGridBuilds() {
        let m = material(.Grid)
        m.properties = ViewProperties()
        m.properties?.spacing = 8
        let row = material(.GridRow)
        row.subviews = [material(.Text), material(.Text)]
        m.subviews = [row]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testGridRowBuilds() {
        let m = material(.GridRow)
        m.subviews = [material(.Rectangle), material(.Circle)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    // MARK: - Interactive views

    func testButtonWithSubviews() {
        let m = material(.Button)
        m.values = Values()
        m.values?.actionId = "btn1"
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m, onAction: { _ in }).toPresentable()
    }

    func testButtonWithTextOnly() {
        let m = material(.Button)
        m.values = Values()
        m.values?.text = "Click"
        m.values?.actionId = "btn2"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testButtonDefaultActionId() {
        let m = material(.Button)
        m.values = Values()
        // No actionId set — should use "button" default
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testNavigationStackBuilds() {
        let m = material(.NavigationStack)
        m.subviews = [material(.Text)]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testNavigationLinkWithTwoSubviews() {
        let m = material(.NavigationLink)
        let dest = material(.Text)
        dest.values = Values()
        dest.values?.text = "Destination"
        let label = material(.Text)
        label.values = Values()
        label.values?.text = "Go"
        m.subviews = [dest, label]
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testNavigationLinkWithTextOnly() {
        let m = material(.NavigationLink)
        m.values = Values()
        m.values?.text = "Link"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testToggleBuilds() {
        let m = material(.Toggle)
        m.values = Values()
        m.values?.text = "Toggle"
        m.values?.isOn = true
        m.values?.actionId = "t1"
        let _ = ViewFactory(material: m, onAction: { _ in }).toPresentable()
    }

    func testTextFieldBuilds() {
        let m = material(.TextField)
        m.values = Values()
        m.values?.placeholder = "Enter..."
        m.values?.text = "Initial"
        m.values?.actionId = "tf1"
        let _ = ViewFactory(material: m, onAction: { _ in }).toPresentable()
    }

    func testColorViewWithForeground() {
        let m = material(.Color)
        m.properties = ViewProperties()
        m.properties?.foregroundColor = "#FF0000"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testColorViewWithBackground() {
        let m = material(.Color)
        m.properties = ViewProperties()
        m.properties?.backgroundColor = "#00FF00"
        let _ = ViewFactory(material: m).toPresentable()
    }

    func testColorViewNoColor() {
        let m = material(.Color)
        // No properties — should render clear
        let _ = ViewFactory(material: m).toPresentable()
    }

    // MARK: - Nil type

    func testNilTypeRendersEmptyView() {
        let m = ViewMaterial()
        m.type = nil
        let _ = ViewFactory(material: m).toPresentable()
    }

    // MARK: - All modifiers applied without crash

    func testAllModifiersApplied() {
        let m = material(.Rectangle)
        m.properties = ViewProperties()
        m.properties?.padding = 10
        m.properties?.foregroundColor = "#FF0000"
        m.properties?.backgroundColor = "#00FF00"
        m.properties?.cornerRadius = 8
        m.properties?.clipShape = "capsule"
        m.properties?.borderColor = "#0000FF"
        m.properties?.borderWidth = 2
        m.properties?.shadowColor = "#000000"
        m.properties?.shadowRadius = 5
        m.properties?.shadowX = 2
        m.properties?.shadowY = 3
        m.properties?.opacity = 0.8
        m.properties?.rotation = 45
        m.properties?.blur = 2
        m.properties?.grayscale = 0.5
        m.properties?.width = 100
        m.properties?.height = 100
        m.properties?.maxWidth = 200
        m.properties?.maxHeight = 200
        m.properties?.accessibilityLabel = "Box"
        m.properties?.accessibilityHint = "A red box"
        m.properties?.accessibilityHidden = false

        let _ = ViewFactory(material: m).toPresentable()
    }

    // MARK: - Helpers

    private func material(_ type: ViewType) -> ViewMaterial {
        let m = ViewMaterial()
        m.type = type
        return m
    }
}
