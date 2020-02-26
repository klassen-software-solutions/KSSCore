//
//  NSApplicationExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-25.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Cocoa


public extension NSApplication {

    /**
     Return the name of the application as read from the bundle.
     */
    var name: String { Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String }
    
}
