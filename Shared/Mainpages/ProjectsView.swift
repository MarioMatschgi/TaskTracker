//
//  TrackView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// Main view with a list of all Projects
struct ProjectsView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var selected: Project? = nil
    
    var body: some View {
        NavigationView {
            List(model.projects, id: \.id) { project in
                NavigationLink(project.name ?? "", tag: project, selection: $selected) {
                    if selected != nil {
                        ProjectDetailView(project: selected!)
                    }
                }.contextMenu {
                    Button {
                        removeItem(project)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            
            Text("Choose a project")
        }.onAppear {
            if let uid = userDefaults.string(forKey: KEYS.PROJECTS_SELECTED) {
                selected = model.projects.first(where: { task in
                    task.id == UUID(uuidString: uid)
                })
            }
        }
        .onDisappear {
            userDefaults.set(selected?.id?.uuidString, forKey: KEYS.PROJECTS_SELECTED)
        }
        .navigationTitle(selected?.name ?? "Projects")
        .navigationSubtitle(selected != nil ? "Projects" : "")
        .toolbar {
            ToolbarItem {
                Button {
                    removeItem()
                } label: {
                    Label("Delete project", systemImage: "trash")
                }.disabled(selected == nil)
            }
            ToolbarItem {
                Button {
                    addItem()
                } label: {
                    Label("Add project", systemImage: "plus")
                }
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = Project(context: viewContext)
            newItem.id = UUID()
            newItem.name = "New Project"
            newItem.tasks = []
            
            selected = newItem

            viewContext.safeSave()
        }
    }
    
    func removeItem(_ item: Project? = nil) {
        withAnimation {
            if let t = item ?? selected {
                viewContext.delete(t)
                
                selected = nil
                
                viewContext.safeSave()
            }
        }
    }
}
