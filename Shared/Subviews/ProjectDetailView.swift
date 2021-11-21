//
//  TaskDetailView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// View that shows the details for a given Project
struct ProjectDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var project: Project
    @State var update = false
    @State var selected: Task? = nil
    @State var edit: Task? = nil
    
    var body: some View {
        if update { }
        VStack {
            Form {
                HStack {
                    TextField("Name", text: Binding($project.name, ""), onCommit: {
                        viewContext.safeSave()
                    })
                    Button {
                        let new = Task(context: viewContext)
                        new.start = Date().withoutSeconds()
                        new.end = Date().withoutSeconds()
                        edit = new
                    } label: {
                        Text("Add task")
                    }
                }
            }
            
            HStack {
                Text("Total: " + project.getFullDuration())
                Spacer()
            }
            
            Divider()
            
            if project.tasksArr.count > 0 {
                VStack {
                    HStack {
                        Text("Start")
                            .frame(width: 55, alignment: .leading)
                        Text("End")
                            .frame(width: 55, alignment: .leading)
                        Text("Description")
                            .frame(alignment: .leading)
                        Spacer()
                        Text("Duration")
                    }
                    List(project.tasksArr, id: \.self, selection: $selected) { task in
                        HStack {
                            Text(task.toStringStart())
                                .frame(width: 55, alignment: .leading)
                            Text(task.toStringEnd())
                                .frame(width: 55, alignment: .leading)
                            Text(task.desc ?? "")
                            Spacer()
                            Text(DateTimeUtil.getTimeDiffFormatted(task.start!, task.end, showZeroS: true))
                            Button {
                                edit = task
                            } label: {
                                Image(systemName: "pencil")
                            }.buttonStyle(PlainButtonStyle())
                            Button {
                                removeItem(task)
                            } label: {
                                Image(systemName: "trash")
                            }.buttonStyle(PlainButtonStyle())
                        }.contextMenu {
                            Button {
                                edit = task
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button {
                                removeItem(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }.padding(.leading, -15)
                    .padding(.bottom, -23)
                    .padding(.trailing, -15)
                }
            } else {
                Text("No tasks")
            }
            Spacer()
        }.padding()
        .sheet(item: $edit, onDismiss: {
            edit = nil
            update.toggle()
        }) { task in
            TaskView(project: project, task: task, mode: task.project == nil ? .create : .update)
                .padding()
                .frame(width: 300, height: 150)
                .fixedSize()
        }
    }
    
    func removeItem(_ task: Task) {
        withAnimation {
            viewContext.delete(task)
            
            update.toggle()
            viewContext.safeSave()
        }
    }
}
