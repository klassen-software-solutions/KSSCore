//
//  Duration.swift
//  
//
//  Created by Steven W. Klassen on 2020-06-09.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(os)
import os
#endif

import Foundation


/**
 Create a duration of the given units and return it as a `TimeInterval.`
 - warning: The resulting time interval will be approximate, using the assumptions described
 for the `DurationUnit`.
 */
public func duration(_ count: Double, _ unit: DurationUnit) -> TimeInterval {
    return count * unit.rawValue
}


/**
 Create a duration of the given units and return it as a `TimeInterval.` This version creates a duration
 assuming the given starting time and will take into account the correct calendar information in terms
 of days of the month and so on. If the calendar cannot compute an appropriate interval, then `nil` is
 returned.
 */
public func duration(_ count: Int, _ unit: DurationUnit, from start: Date = Date()) -> TimeInterval? {
    var component = DateComponents()
    switch unit {
    case .seconds:  component.second = count
    case .minutes:  component.minute = count
    case .hours:    component.hour = count
    case .days:     component.day = count
    case .weeks:    component.day = count * 7
    case .months:   component.month = count
    case .years:    component.year = count
    }

    guard let newDate = Calendar.current.date(byAdding: component, to: start) else {
        os_log("warning: could not compute the requested interval, using an approximation")
        return nil
    }

    return newDate.timeIntervalSince(start)
}

/**
 Enumeration to specify the unit of a given duration. The raw value of the enumeration is a TimeInterval
 that specifies the conversion from this unit into seconds.

 - warning:
 This conversion is only approximate and does not consider leap years or even the difference between
 months. Most of the time this will not matter, but if the more accurate conversion fails, these values will
 be used as a fallback mechanism for generating the interval.
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
