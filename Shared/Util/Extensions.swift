//
//  Extentions.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation
import SwiftUI
import CoreData
import WidgetKit

let userDefaults = UserDefaults.standard

extension NSManagedObjectContext {
    func safeSave() {
        do {
            try self.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        if source.wrappedValue == nil {
            self.init(
                get: { source.wrappedValue ?? defaultValue },
                set: { newValue in
                    source.wrappedValue = newValue
                }
            )
        } else {
            self.init(source)!
        }
    }
}

extension String {
    func local() -> String {
        return NSLocalizedString(self, tableName: "lang", bundle: .main, value: self, comment: self)
    }
}

enum CRUDMode {
    case create
    case read
    case update
    case delete
}

extension Date {
    func withoutSeconds() -> Date {
        return self.addingTimeInterval(-1 * TimeInterval(Double(self.timeIntervalSince1970.millisecond) / Double(1000)))
    }
}
