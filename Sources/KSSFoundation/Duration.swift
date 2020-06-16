//
//  Duration.swift
//  
//
//  Created by Steven W. Klassen on 2020-06-09.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation


/**
 Create a duration of the given units and return it as a `TimeInterval.`
 */
public func duration(_ count: Double, _ unit: DurationUnit) -> TimeInterval {
    return count * unit.rawValue
}


/**
 Enumeration to specify the unit of a given duration. The raw value of the enumeration is a TimeInterval
 that specifies the conversion from this unit into seconds.

 - warning:
 This conversion is only approximate and does not consider leap years or even the difference between
 months. For example, one year will always be considered 365 days and one month will always be considered
 30 days. For more accurate durations you will need to use the `Date` and related classes directly.
 */
public enum DurationUnit: TimeInterval {
    /// Conversion of one second to a `TimeInterval`
    case seconds = 1.0

    /// Conversion of one minute to a `TimeInterval`
    case minutes = 60.0

    /// Conversion of one hour to a `TimeInterval`
    case hours = 3600.0

    /// Conversion of one day to a `TimeInterval`
    case days = 86400.0
    
    /// Conversion of one week to a `TimeInterval`
    case weeks = 604800.0

    /// Conversion of one month to a `TimeInterval`
    /// - warning: This conversion considers one month to be 30 days
    case months = 2592000.0

    /// Conversion of one year to a `TimeInterval`
    /// - warning: This conversion considers one year to be 365 days
    case years = 31536000.0
}
