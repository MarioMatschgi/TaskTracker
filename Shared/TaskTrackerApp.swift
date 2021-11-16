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
    @StateObject var model: Model

    init() {
        let managedObjectContext = persistenceController.container.viewContext
        let storage = Model(managedObjectContext: managedObjectContext)
        self._model = StateObject(wrappedValue: storage)
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.commands {
            SidebarCommands()
        }
    }
}
