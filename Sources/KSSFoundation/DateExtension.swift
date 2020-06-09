//
//  DateExtension.swift
//
//  Created by Steven W. Klassen on 2020-06-04.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation

public extension Date {

    /**
     Display a description of the time but in the given time zone. Note that the format will always be
     `yyyy-MM-dd HH:mm:ss z` as this is intended primarily for debugging logs. For locale specific
     descriptions (as opposed to just time zone changes), you should still use `description(with: Locale?)`.
     */
    func description(inTimeZone timeZone: TimeZone) -> String {
        let format = DateFormatter()
        format.timeZone = timeZone
        format.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        return format.string(from: self)
    }
}
