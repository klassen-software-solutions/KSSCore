//
//  DataExtension.swift
//  
//
//  Created by Steven W. Klassen on 2020-03-13.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation

public extension Data {

    /**
     Read in data from an input stream.

     - warning:
        This method assumes that the stream is limited in size (e.g. a file) and will end. If you call this on an
        unending stream, say for example a network connect, then it will never return.

     - throws: An NSError object if the stream read fails.
     */
    init(fromInputStream inStream: InputStream) throws {
        self.init()
        inStream.open()
        defer { inStream.close() }

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        while inStream.hasBytesAvailable {
            let read = inStream.read(buffer, maxLength: bufferSize)
            if read < 0 {
                throw inStream.streamError!
            } else if read == 0 {
                break
            }
            self.append(buffer, count: read)
        }
    }
}
