//
//  FileSystemWatcherTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-09.
//

import Foundation
import KSSTest
import XCTest

@testable import KSSFoundation

@available(OSX 10.12, *)
class FileSystemWatcherTests: XCTestCase {
    let watcher = FileSystemWatcher()
    let fileManager = FileManager.default
    var directory: URL? = nil
    var watcherId: UUID? = nil

    override func setUp() {
        directory = try! fileManager.createTemporaryDirectory(withPrefix: "FileSystemWatcherTests")
    }

    override func tearDown() {
        if let watcherId = watcherId {
            watcher.stopWatching(watcherId)
            self.watcherId = nil
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
        //try XCTSkipIf(true)

        watcherId = try? watcher.watch(directory!, flags: [.fileEvents, .watchRoot], latency: 0) { events in
            print("received \(events.count) events:")
            for event in events {
                print("  event: \(event)")
            }
        }

        let path = directory!.appendingPathComponent("testfile.dat")
        print("file: \(path.path)")

        while true {
            print("creating file...")
            fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
            sleep(5)

            print("removing file...")
            try? fileManager.removeItem(at: path)

            //watcher.flushAll()
            print("!! waiting...")
            sleep(5)
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

    func testThatFileCreationIsObserved1() {
        var expectation: XCTestExpectation? = self.expectation(description: "File creation should trigger event")
        watcherId = try! watcher.watch(directory!, flags: .fileEvents) { events in
            for event in events {
                print("event: \(event)")
                if event.eventType == .created {
                    expectation?.fulfill()
                    expectation = nil
                    break
                }
            }
        }
        let filePath = directory!.appendingPathComponent("testfile.dat").path
        print("!! filePath: \(filePath)")
        fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        waitForExpectations(timeout: 2, handler: nil)
    }


    func testThatFileCreationIsObserved() throws {
        print("start of test")
        expectWillFulfill(within: 5) { expectation in
            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents], latency: 0) { events in
                print("111")
                for event in events {
                    print("event: \(event)")
                    if event.eventType == .created {
                        expectation.fulfill()
                        break
                    }
                }
            }
            assertEqual(to: 1) { watcher.streams.count }

            let path = directory!.appendingPathComponent("testfile.dat")
            print("creating file: \(path)")
            fileManager.createFile(atPath: path.absoluteString, contents: nil, attributes: nil)
        }
    }

    func testThatFileDeletionIsObserved() throws {
        expectWillFulfill { expectation in
            let path = directory!.appendingPathComponent("testfile.dat")
            fileManager.createFile(atPath: path.absoluteString, contents: nil, attributes: nil)

            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents]) { events in
                for event in events {
                    if event.eventType == .removed {
                        expectation.fulfill()
                        break
                    }
                }
            }

            try? fileManager.removeItem(at: path)
        }
    }

    func testThatFileChangesAreObserved() throws {
        expectWillFulfill { expectation in
            let path = directory!.appendingPathComponent("testfile.dat")
            fileManager.createFile(atPath: path.absoluteString, contents: nil, attributes: nil)

            watcherId = try? watcher.watch(directory!, flags: [.noDefer, .fileEvents]) { events in
                for event in events {
                    if event.eventType == .modified {
                        expectation.fulfill()
                        break
                    }
                }
            }

            try? "This is a change".write(to: path, atomically: true, encoding: .utf8)
        }
    }
}
