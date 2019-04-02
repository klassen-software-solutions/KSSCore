//
//  NSViewControllerExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-12.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Cocoa
import Foundation



public extension NSViewController {

    /*!
     Search for and create if necessary a common directory for the containing application.
     */
    func findOrCreateApplicationDirectory(for directory: FileManager.SearchPathDirectory,
                                          in domain: FileManager.SearchPathDomainMask) throws -> URL
    {
        // Determine the required directory path.
        let fileManager = FileManager.default
        let commonURL = try fileManager.url(for: directory,
                                            in: domain,
                                            appropriateFor: nil,
                                            create: true)
        let applicationName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let applicationDirectoryURL = commonURL.appendingPathComponent(applicationName)

        // Find or create it.
        try fileManager.findOrCreateDirectory(at: applicationDirectoryURL,
                                              withIntermediateDirectories: true)
        return applicationDirectoryURL
    }
}
