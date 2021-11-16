//
//  DateTimeUtil.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation

class DateTimeUtil {
    static func getTimeDiffFormatted(_ date: Date, _ till: Date? = nil) -> String {
        let timeDiff = date.distance(to: till ?? Date())
        return timeDiff.diffString
    }
}
