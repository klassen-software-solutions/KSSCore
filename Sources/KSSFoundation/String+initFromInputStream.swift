//
//  String+initFromInputStream.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation


public extension String {

    /**
     Create a string given the contents of an input stream and its encoding. Note that this will
     return `nil` if there is an error either in reading from the stream or in the data decoding.
     */
    init?(contentsOfStream stream: InputStream, encoding: String.Encoding) {
        if let data = try? Data(fromInputStream: stream) {
            self.init(data: data, encoding: encoding)
        } else {
            return nil
        }
    }
}
