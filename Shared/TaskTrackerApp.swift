//
//  TaskTrackerApp.swift
//  Shared
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

@main
struct TaskTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
