//
//  InputStreamReader.swift
//  
//
//  Created by Steven W. Klassen on 2021-03-20.
//

import Foundation


/**
 Read an input stream in blocks. This object is designed to be able to efficiently
 read small inputs (less than a block size) in their entirety while using a multiple
 block approach for larger inputs, hence ensuring the entire input does not need
 to be held in memory at once.

 It was written for the CREST project (https://github.com/klassen-software-solutions/crest)
 to allow it to read the standard input device and submit it to an HTTP server using
 a single operation for smaller inputs and a chunked approach for larger inputs.
 */
public struct InputStreamReader {

    let inputStream: InputStream?
    let buffer: UnsafeMutablePointer<UInt8>?
    let bufferSize: Int
    var bufferCount = 0

    /**
     True if the input stream has no data.
     */
    public let empty: Bool

    /**
     True if the input stream contains more than one buffer of data.
     */
    public let largeStream: Bool

    /**
     Construct a reader for the input stream. Note that the stream will be opened. You
     will need to call close at some point.
     */
    public init(_ inputStream: InputStream, withBufferSize bufferSize: Int = 2048) throws {
        print("!! init")
        inputStream.open()
        print("!! opened")
        fakeReadToForceAvailableCheck(inputStream)
        self.empty = !inputStream.hasBytesAvailable
        print("!! isEmpty: \(self.empty)")
        self.bufferSize = bufferSize
        if self.empty {
            print("!! is empty, closing")
            inputStream.close()
            self.inputStream = nil
            self.buffer = nil
        } else {
            print("!! is not empty, attempt to read")
            self.inputStream = inputStream
            self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            print("!! before read next buffer")
            self.bufferCount = try readNextBuffer(inputStream, self.buffer!, bufferSize)
            print("!! after read next buffer, count=\(self.bufferCount)")
        }
        self.largeStream = self.bufferCount >= bufferSize
    }

    /**
     Close the input stream.
     */
    public func close() {
        self.inputStream?.close()
        self.buffer?.deallocate()
    }

    /**
     Returns the next block of data. Returns nil if there is no more.

     - note: For efficiency the data should be considered immutable and should be used
        before nextBlock is called again.
     - note: If `largeStream` is false, then you may assume that the first call to
        to `nextDataBlock` will have read the data in its entirity.
     */
    public mutating func nextDataBlock() throws -> Data? {
        guard let inputStream = inputStream else {
            return nil
        }
        guard self.bufferCount >= 0 else {
            return nil
        }
        precondition(self.buffer != nil)

        if self.bufferCount == 0 {
            self.bufferCount = try readNextBuffer(inputStream, self.buffer!, bufferSize)
        }
        if self.bufferCount == 0 {
            self.bufferCount = -1
            return nil
        }
        let count = self.bufferCount
        self.bufferCount = 0
        return Data(bytesNoCopy: self.buffer!, count: count, deallocator: .none)
    }
}


fileprivate func fakeReadToForceAvailableCheck(_ inputStream: InputStream) {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    _ = inputStream.read(buffer, maxLength: 0)
    buffer.deallocate()
}

fileprivate func readNextBuffer(_ inputStream: InputStream,
                                _ buffer: UnsafeMutablePointer<UInt8>,
                                _ bufferSize: Int) throws -> Int
{
    print("!! before stream read, available: \(inputStream.hasBytesAvailable)...")
    _ = inputStream.read(buffer, maxLength: 0)
    print("!! after fake read, available: \(inputStream.hasBytesAvailable)")
    guard inputStream.hasBytesAvailable else {
        return 0
    }
    let read = inputStream.read(buffer, maxLength: bufferSize)
    print("!! after stream read, read=\(read)")
    if read < 0 {
        throw inputStream.streamError!
    }
    return read
}
