//
//  os_log.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-11.
//

import Foundation

#if canImport(os)
#else

// This is a basic os_log for use in Linux. Note that it is not made public at
// this time and is only complete enough to handle the logging used within this
// library.

func os_log(_ message: StaticString, _ args: Any...) {
    let regex = try! NSRegularExpression(pattern: "%[@sdf]")
    var outputMessage: String = "\(message)"
    for arg in args {
        if let match = regex.firstMatch(in: outputMessage, options: [], range: outputMessage.range) {
            if let range = Range(match.range(at: 0), in: outputMessage) {
                outputMessage.replaceSubrange(range, with: "\(arg)")
            }
        }
    }
    print(outputMessage)
}

#endif
