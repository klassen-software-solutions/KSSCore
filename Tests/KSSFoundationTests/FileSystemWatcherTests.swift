//
//  FileSystemWatcherTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-09.
//

import XCTest

#if os(macOS) || os(iOS)

import Foundation
import KSSTest

@testable import KSSFoundation

class FileSystemWatcherTests: XCTestCase {
    let watcher = FileSystemWatcher()
    let fileManager = FileManager.default
    var directory: URL? = nil
    var watcherId: UUID? = nil
    var watcherId2: UUID? = nil

    override func setUp() {
        directory = try! fileManager.createTemporaryDirectory(withPrefix: "FileSystemWatcherTests")
    }

    override func tearDown() {
        if let watcherId = watcherId {
            watcher.stopWatching(watcherId)
            self.watcherId = nil
        }

        if let watcherId = watcherId2 {
            watcher.stopWatching(watcherId)
            self.watcherId2 = nil
        }

        if let directory = directory {
            try! fileManager.trashItem(at: directory, resultingItemURL: nil)
            self.directory = nil
        }
    }

    func testManually() throws {
        // This "test" simply starts a watcher and echoes whatever happens to the
        // output log. Enable the test and run it if you want to perform manual
        // tests. But don't check it in with this test enabled as this test
        // contains an infinite loop.
        try XCTSkipIf(true)

        watcherId = try? watcher.watch(directory!, flags: [.fileEvents, .watchRoot], latency: 0) { events in
            print("received \(events.count) events:")
            for event in events {
                print("  event: \(event)")
            }
        }

        while true {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 10, true);
            print("waiting...")
        }
    }

    func testInvalidWatches() throws {
        let badUrl = URL(string: "http://localhost/")!
        assertThrowsError(ofValue: FileSystemWatcher.Error.notAFile(url: badUrl)) {
            _ = try watcher.watch(badUrl) { _ in }
        }
        assertTrue { watcher.streams.isEmpty }

        assertThrowsError(ofValue: FileSystemWatcher.Error.notAFile(url: badUrl)) {
            let urls = [
                fileManager.homeDirectoryForCurrentUser,
                badUrl,
                fileManager.temporaryDirectory
            ]
            _ = try watcher.watch(urls) { _ in }
        }
        assertTrue { watcher.streams.isEmpty }

        let badFlag = FileSystemWatcher.Flags(rawValue: FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes))
        assertThrowsError(ofValue: FileSystemWatcher.Error.unsupportedFlags(badFlags: badFlag)) {
            let flags = badFlag.union(.fileEvents)
            let goodUrl = fileManager.homeDirectoryForCurrentUser
            _ = try watcher.watch(goodUrl, flags: flags) { _ in }
        }
        assertTrue { watcher.streams.isEmpty }
    }

    func testThatFileCreationIsObserved() throws {
        let url = directory!.appendingPathComponent("testfile.dat")
        expect(within: 0.1) {
            let expectation = self.expectation(description: "File creation should trigger event")
            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents], latency: 0) { events in
                for event in events {
                    if event.url.path == url.path && (event.eventTypes.contains(.created) || event.eventTypes.contains(.renamed)) {
                        self.assertTrue { event.itemTypes.contains(.file) }
                        self.assertTrue { event.isOurOwnEvent }
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
    }

    func testThatFileDeletionIsObserved() throws {
        expect {
            let expectation = self.expectation(description: "File deletion should trigger event")
            let url = directory!.appendingPathComponent("testfile.dat")
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)

            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents]) { events in
                for event in events {
                    if event.eventTypes.contains(.removed) {
                        self.assertEqual(to: url.path) { event.url.path }
                        self.assertTrue { event.itemTypes.contains(.file) }
                        self.assertTrue { event.isOurOwnEvent }
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            try? fileManager.removeItem(at: url)
        }
    }

    func testThatFileChangesAreObserved() throws {
        expect {
            var somethingWasModified: XCTestExpectation? = self.expectation(description: "Something should be modified")
            var wasRenamed: XCTestExpectation? = self.expectation(description: "Modified file is renamed to our name")
            let url = directory!.appendingPathComponent("testfile.dat")
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)

            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents]) { events in
                for event in events {
                    if event.eventTypes.contains(.modified) {
                        self.assertTrue { event.eventTypes.contains(.metadataModified(inode: false, finder: false, xAttributes: true)) }
                        self.assertTrue { event.isOurOwnEvent }
                        somethingWasModified?.fulfill()
                        somethingWasModified = nil
                    }
                    if event.eventTypes.contains(.renamed) && event.url.path == url.path {
                        self.assertTrue { event.isOurOwnEvent }
                        wasRenamed?.fulfill()
                        wasRenamed = nil
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            try? "This is a change".write(to: url, atomically: true, encoding: .utf8)
        }
    }

    func testThatWeCanIgnoreOurOwnEvents() throws {
        let url = directory!.appendingPathComponent("testfile.dat")
        expect(within: 0.1) {
            let expectation = self.expectation(description: "File creation should trigger event")
            expectation.isInverted = true
            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .ignoreSelf, .fileEvents], latency: 0) { events in
                for event in events {
                    if event.url.path == url.path && (event.eventTypes.contains(.created) || event.eventTypes.contains(.renamed)) {
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
    }

    func testThatRootDirectoryIsObserved() throws {
        expect {
            let expectation = self.expectation(description: "Root directory removal should trigger event")
            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .watchRoot], latency: 0) { events in
                for event in events {
                    if event.eventTypes.contains(.rootChanged) {
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            try! fileManager.trashItem(at: self.directory!, resultingItemURL: nil)
            self.directory = nil
        }
    }

    func testThatRootDirectoryIsNotObserved() throws {
        expect(within: 0.1) {
            let expectation = self.expectation(description: "Root directory removal should not trigger event")
            expectation.isInverted = true
            watcherId = try? watcher.watch(directory!, flags: [.noDefer], latency: 0) { events in
                for event in events {
                    if event.eventTypes.contains(.rootChanged) {
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }
            try! fileManager.trashItem(at: self.directory!, resultingItemURL: nil)
            self.directory = nil
        }
    }

    func testMultipleWatchers() throws {
        expect(within: 0.1) {
            let shouldNotTrigger = self.expectation(description: "Root directory removal should not trigger event")
            shouldNotTrigger.isInverted = true
            watcherId = try? watcher.watch(directory!, flags: [.noDefer], latency: 0) { events in
                for event in events {
                    if event.eventTypes.contains(.rootChanged) {
                        shouldNotTrigger.fulfill()
                        break
                    }
                }
            }

            let shouldTrigger = self.expectation(description: "Root directory removal should trigger event")
            watcherId2 = try? watcher.watch(directory!, flags: [.noDefer, .watchRoot], latency: 0) { events in
                for event in events {
                    if event.eventTypes.contains(.rootChanged) {
                        shouldTrigger.fulfill()
                        break
                    }
                }
            }

            assertEqual(to: 2) { watcher.streams.count }
            try! fileManager.trashItem(at: self.directory!, resultingItemURL: nil)
            self.directory = nil
        }
    }
}

#else

// "Dummy" version needed for Linux since the auto-building of XCTestManifests.swift
// is taking place on the Mac and doesn't know to ignore these tests.
class FileSystemWatcherTests: XCTestCase {
    func testManually() throws {}
    func testInvalidWatches() throws {}
    func testThatFileCreationIsObserved() throws {}
    func testThatFileDeletionIsObserved() throws {}
    func testThatFileChangesAreObserved() throws {}
    func testThatWeCanIgnoreOurOwnEvents() throws {}
    func testThatRootDirectoryIsObserved() throws {}
    func testThatRootDirectoryIsNotObserved() throws {}
    func testMultipleWatchers() throws {}
}

#endif
