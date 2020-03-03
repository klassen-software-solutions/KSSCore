//
//  FileManagerExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-12.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Foundation


public extension FileManager {

    /**
     Search for a directory and create it if it does not already exist.

     - parameters:
        - url: The URL of the directory to find (or create).
        - createIntermediates: If true then any intermediate directories are also created.
        - attributes: File attributes for the directory, if it is created.

     - throws:
     Any error that may be thrown by createDirectory.
     
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

    /**
     Returns true if the given directory exists and false otherwise.
     */
    func directoryExists(at url: URL) -> Bool {
        precondition(url.scheme == nil || url.scheme == "file",
                     "The URL \(url.absoluteString) does not reference a file scheme.")
        return directoryExists(atPath: url.path)
    }

    /**
     Returns true if the given directory exists and false otherwise.
     */
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        if !fileExists(atPath: path, isDirectory: &isDirectory) {
            return false
        }
        return isDirectory.boolValue
    }


    /**
     Creates a temporary directory that matches the given prefix, and returns a URL that references it.

     - parameters:
        - withPrefix: A prefix that will be used for the directory name. Note that this is just the prefix
            of the directory, not the path that leads to the directory.
     */
    @available(OSX 10.12, *)
    func createTemporaryDirectory(withPrefix prefix: String = "temp_") throws -> URL {
        let directoryName = prefix + UUID().uuidString
        let url = temporaryDirectory.appendingPathComponent(directoryName, isDirectory: true)
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }

    /**
     Returns the attributes of the file at the given URL. This is just a wrapper around `attributesOfItem(atPath)`.
     */
    func attributesOfItem(at url: URL) throws -> [FileAttributeKey: Any] {
        return try attributesOfItem(atPath: url.path)
    }

}
