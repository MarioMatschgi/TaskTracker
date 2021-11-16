//
//  Data.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation
import SwiftUI

enum PageType {
    case home
    case track
    case history
}

extension Task {
    var entriesArr: [TaskEntry] {
        return (self.entries! as! Set<TaskEntry>).sorted(by: { e1, e2 in
            e1.start! > e2.start!
        })
    }
}

extension TaskEntry {
    func toString() -> String {
        var str = "\(start!.formatted(date: .omitted, time: .standard))-"
        if end == nil {
            str += "now"
        } else {
            str += end!.formatted(date: .omitted, time: .standard)
        }
        return str
    }
}

extension TimeInterval {
    var diffString: String {
        var str = ""
        if day > 0 {
            str += " \(day)d"
        }
        if hour > 0 {
            str += " \(hour)h"
        }
        if minute > 0 {
            str += " \(minute)m"
        }
        if second > 0 {
            str += " \(second)s"
        }
        
        return str.trimmingCharacters(in: .whitespaces)
    }
    var day: Int {
        Int((self/86400).truncatingRemainder(dividingBy: 86400))
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
