//
//  FileManagerExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-12.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Foundation


public extension FileManager {

    /*!
     Search for a directory and create it if it does not already exist.
     */
    func findOrCreateDirectory(at url: URL,
                               withIntermediateDirectories createIntermediates: Bool,
                               attributes: [FileAttributeKey: Any]? = nil) throws
    {
        var isDirectory = ObjCBool(false)
        let fullPath = url.absoluteString
        if !fileExists(atPath: fullPath, isDirectory: &isDirectory) {
            try createDirectory(at: url,
                                withIntermediateDirectories: createIntermediates,
                                attributes: attributes)
        }
        else if !isDirectory.boolValue {
            throw NSError.init(domain: NSPOSIXErrorDomain,
                               code: kPOSIXErrorEEXIST,
                               userInfo: [NSLocalizedDescriptionKey: "URL already exists but is not a directory"])
        }
    }
}
