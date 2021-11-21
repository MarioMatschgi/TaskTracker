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
    
    @State var selected: Project? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                TrackProjectView(project: $selected)
            }.frame(height: 100)
            List(model.projects, id: \.id, selection: $selected) { project in
                HStack {
                    Image(systemName: project.isTracking ? "stop.circle" : "play.fill")
                    Text(project.name!)
                    Spacer()
                }.tag(project)
            }
        }.onAppear {
            if let uid = userDefaults.string(forKey: KEYS.HOME_PROJECT_SELECTED) {
                selected = model.projects.first(where: { project in
                    project.id == UUID(uuidString: uid)
                })
            }
        }
        .onDisappear {
            userDefaults.set(selected?.id?.uuidString, forKey: KEYS.HOME_PROJECT_SELECTED)
        }
        .navigationTitle(selected?.name ?? "Home")
        .navigationSubtitle(selected != nil ? "Home" : "")
        .toolbar {
            ToolbarItem {
                Button {
                    print("View - deeplink to project")
                } label: {
                    Label("View project", systemImage: "info.circle")
                }
            }
        }
    }
}
