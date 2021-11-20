//
//  TrackView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// Main view with a list of all Tasks
struct TaskView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var selected: Task? = nil
    
    var body: some View {
//        Text("Add new tasks to track, remove existing ones, etc.")
        NavigationView {
            List(model.tasks, id: \.id) { task in
                NavigationLink(task.name ?? "", tag: task, selection: $selected) {
                    if selected != nil {
                        TaskDetailView(task: selected!)
                    }
                }.contextMenu {
                    Button {
                        removeItem(task)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            
            Text("Choose a task")
        }.onAppear {
            if let uid = userDefaults.string(forKey: KEYS.TASKS_SELECTED) {
                selected = model.tasks.first(where: { task in
                    task.id == UUID(uuidString: uid)
                })
            }
        }
        .onDisappear {
            userDefaults.set(selected?.id?.uuidString, forKey: KEYS.TASKS_SELECTED)
        }
        .navigationTitle(selected?.name ?? "Tasks")
        .navigationSubtitle(selected != nil ? "Tasks" : "")
        .toolbar {
            ToolbarItem {
                Button {
                    removeItem()
                } label: {
                    Label("Remove task", systemImage: "trash")
                }.disabled(selected == nil)
            }
            ToolbarItem {
                Button {
                    addItem()
                } label: {
                    Label("Add task", systemImage: "plus")
                }
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = Task(context: viewContext)
            newItem.id = UUID()
            newItem.name = "New Task"
            newItem.entries = []
            
            selected = newItem

            viewContext.safeSave()
        }
    }
    
    func removeItem(_ item: Task? = nil) {
        withAnimation {
            if let t = item ?? selected {
                viewContext.delete(t)
                
                selected = nil
                
                viewContext.safeSave()
            }
        }
    }
}
