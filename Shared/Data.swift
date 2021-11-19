//
//  Data.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation
import SwiftUI

class KEYS {
    static let HOME_TASKS_SELECTED = "home.tasks.selected"
    static let TASKS_SELECTED = "tasks.selected"
}

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
        return "\(toStringStart())-\(toStringEnd())"
    }
    func toStringStart() -> String {
        return start!.formatted(date: .omitted, time: .shortened)
    }
    func toStringEnd() -> String {
        if end == nil {
            return "now"
        } else {
            return end!.formatted(date: .omitted, time: .shortened)
        }
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
