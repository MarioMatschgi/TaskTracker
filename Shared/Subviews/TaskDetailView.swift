//
//  TaskDetailView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// View that shows the details of a given Task
struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var task: Task
    @State var update = false
    @State var selected: TaskEntry? = nil
    @State var edit: TaskEntry? = nil
    
    var body: some View {
        if update { }
        VStack {
            Form {
                HStack {
                    TextField("Name", text: Binding($task.name, ""), onCommit: {
                        viewContext.safeSave()
                    })
                    Button {
                        let new = TaskEntry(context: viewContext)
                        new.start = Date().withoutSeconds()
                        new.end = Date().withoutSeconds()
                        edit = new
                    } label: {
                        Text("Add entry")
                    }
                }
            }
            
            HStack {
                Text("Total: " + task.getFullDuration())
                Spacer()
            }
            
            Divider()
            
            if task.entriesArr.count > 0 {
                VStack {
                    HStack {
                        Text("Start")
                            .frame(width: 55, alignment: .leading)
                        Text("End")
                            .frame(width: 55, alignment: .leading)
                        Spacer()
                        Text("Duration")
                    }
                    List(task.entriesArr, id: \.self, selection: $selected) { entry in
                        HStack {
                            Text(entry.toStringStart())
                                .frame(width: 55, alignment: .leading)
                            Text(entry.toStringEnd())
                                .frame(width: 55, alignment: .leading)
                            Spacer()
                            Text(DateTimeUtil.getTimeDiffFormatted(entry.start!, entry.end, showZeroS: true))
                            Button {
                                edit = entry
                            } label: {
                                Image(systemName: "pencil")
                            }.buttonStyle(PlainButtonStyle())
                            Button {
                                removeItem(entry)
                            } label: {
                                Image(systemName: "trash")
                            }.buttonStyle(PlainButtonStyle())
                        }.contextMenu {
                            Button {
                                edit = entry
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button {
                                removeItem(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }.padding(.leading, -15)
                    .padding(.bottom, -23)
                    .padding(.trailing, -15)
                }
            } else {
                Text("No entries")
            }
            Spacer()
        }.padding()
        .sheet(item: $edit, onDismiss: {
            edit = nil
            update.toggle()
        }) { entry in
            TaskEntryView(task: task, entry: entry, mode: entry.task == nil ? .create : .update)
                .padding()
                .frame(width: 300, height: 150)
                .fixedSize()
        }
    }
    
    func removeItem(_ entry: TaskEntry) {
        withAnimation {
            viewContext.delete(entry)
            
            update.toggle()
            viewContext.safeSave()
        }
    }
}

struct TaskEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.undoManager) var undoManager
    
    @State var task: Task
    @State var entry: TaskEntry
    @State var mode: CRUDMode
    
    @State var update = false
    
    var body: some View {
        if update {}
        Form {
            if entry.start != nil {
                DatePicker("Start", selection: Binding($entry.start)!)
            }
            if entry.end != nil {
                DatePicker("End", selection: Binding($entry.end)!)
            } else {
                Button {
                    withAnimation {
                        entry.end = Date().withoutSeconds()
                        entry.task?.isTracking = false
                        viewContext.safeSave()
                        update.toggle()
                    }
                    print("aa")
                } label: {
                    Text("Finish")
                }
            }
        }
        Spacer()
        HStack {
            Button {
                viewContext.rollback()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }.keyboardShortcut(.cancelAction)
            Spacer()
            Button {
                if mode == .create {
                    entry.task = task
                }
                viewContext.safeSave()
                presentationMode.wrappedValue.dismiss()
            } label: {
                if mode == .create {
                    Text("Add")
                } else if mode == .update {
                    Text("Save")
                }
            }.keyboardShortcut(.defaultAction)
        }.onAppear {
            undoManager?.registerUndo(withTarget: entry, handler: { e in
                e.objectWillChange.send()
            })
        }
    }
}
