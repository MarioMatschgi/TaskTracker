//
//  HomeView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// Main view for tracking the time for Tasks
struct HomeView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var selected: Task? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                TrackTaskView(task: $selected)
            }.frame(height: 100)
            List(model.tasks, id: \.id, selection: $selected) { task in
                HStack {
                    Image(systemName: task.isTracking ? "stop.circle" : "play.fill")
                    Text(task.name!)
                    Spacer()
                }.tag(task)
            }
        }.onAppear {
            if let uid = userDefaults.string(forKey: KEYS.HOME_TASKS_SELECTED) {
                selected = model.tasks.first(where: { task in
                    task.id == UUID(uuidString: uid)
                })
            }
        }
        .onDisappear {
            userDefaults.set(selected?.id?.uuidString, forKey: KEYS.HOME_TASKS_SELECTED)
        }
        .navigationTitle(selected?.name ?? "Home")
        .navigationSubtitle(selected != nil ? "Home" : "")
        .toolbar {
            ToolbarItem {
                Button {
                    print("View - deeplink to task")
                } label: {
                    Label("View task", systemImage: "info.circle")
                }
            }
        }
    }
}
