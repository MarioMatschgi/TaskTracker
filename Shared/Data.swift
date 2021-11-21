//
//  Data.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation
import SwiftUI

class KEYS {
    static let MAIN_PAGE_SELECTED = "main.page.selected"
    static let HOME_PROJECT_SELECTED = "home.project.selected"
    static let HOME_PROJECT_DESC = "home.project.desc"
    static let PROJECTS_SELECTED = "projects.selected"
}

enum PageType: String {
    case home
    case projects
    case history
}

extension Project {
    var tasksArr: [Task] {
        return (self.tasks! as! Set<Task>).sorted(by: { e1, e2 in
            e1.start! > e2.start!
        })
    }
}

extension Task {
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
