import XCTest
import KSSCocoa

class NSApplicationExtensionTests: XCTestCase {
    func testMetadata() {
        XCTAssertEqual(NSApplication.shared.name, "xctest")
        XCTAssertNil(NSApplication.shared.version)
        XCTAssertGreaterThan(NSApplication.shared.buildNumber, 0)
    }
}
