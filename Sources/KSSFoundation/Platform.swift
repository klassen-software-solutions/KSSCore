//
//  Platform.swift
//  
//
//  Created by Steven W. Klassen on 2021-03-20.
//

import Foundation


/**
 Provides runtime identification of the operating system.
 */
public struct Platform {
    /**
     Returns the operating system name or "Unknown OS" if it could not be identified.
     */
    public static var operatingSystem: String {
        #if os(macOS)
            return "macOS"
        #elseif os(iOS)
            return "iOS"
        #elseif os(watchOS)
            return "watchOS"
        #elseif os(tvOS)
            return "tvOS"
        #elseif os(Linux)
            return "Linux"
        #elseif os(Windows)
            return "Windows"
        #else
            return "Unknown OS"
        #endif
    }

    /**
     Returns the operating system version.
     This is just a wrapper around ProcessInfo to keep it all in a single API.
     */
    public static var operatingSystemVersion: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }

    /**
     Returns the hardware we are running on or "Unknown Hardware" if it could not
     be identified.
     */
    public static var hardware: String {
        #if arch(i386)
            return "i386"
        #elseif arch(x86_64)
            return "x86_64"
        #elseif arch(arm)
            return "arm"
        #elseif arch(arm64)
            return "arm64"
        #else
            return "Unknown Hardware"
        #endif
    }
}
