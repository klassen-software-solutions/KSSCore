#if canImport(Cocoa)

import XCTest
import KSSCocoa

class NSImageExtensionTests: XCTestCase {
    func testInitFromInputStream() {
        var image = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size.width, 56)
        XCTAssertEqual(image?.size.height, 56)

        image = NSImage(fromInputStream: streamFromEncodedString(notAnImageEncodedString))
        XCTAssertNil(image)
    }

    @available(OSX 10.14, *)
    func testInverted() {
        let inputImage = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))!
        let outputImage = inputImage.inverted()
        XCTAssertEqual(inputImage.size.width, outputImage.size.width)
        XCTAssertEqual(inputImage.size.height, outputImage.size.height)
        XCTAssertNotEqual(inputImage, outputImage)
    }

    func testResized() {
        let image = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))?
            .resized(to: NSSize(width: 16, height: 18))
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size.width, 16)
        XCTAssertEqual(image?.size.height, 18)
    }
}

fileprivate let plusSymbolEncodedString = """
iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAAAYFBMVEUAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAD////68c6fAAAAHnRSTlMAAQgPERYXGSIkJSYnKDg7PJWWmJ+goaLa29zd/P0v
2OJcAAAAAWJLR0QfBQ0QvQAAAHhJREFUSMft1skKgCAQgGG1xTbb93Te/zHToxQYU6eY/zj4HQTBYYz6
edUyFRjHD4CNI2AKtgQBpYOSIEGCNhF7KQeVPxN3rtcQTHdX18Kjmu8gG0yYmeHuklHmVbuTtT+L6MkR
JPgGor9yvgOsmOWBlfOY09L2904sZSVqkhks3wAAAABJRU5ErkJggg==
"""

fileprivate let notAnImageEncodedString = "dGhpcyBzaG91bGQgbm90IGJlIGFuIGltYWdlCg=="

fileprivate func streamFromEncodedString(_ encodedString: String) -> InputStream {
    let decodedData = Data(base64Encoded: encodedString, options: .ignoreUnknownCharacters)!
    return InputStream(data: decodedData)
}

#endif
