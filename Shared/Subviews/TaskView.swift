//
//  TaskView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 21.11.21.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.undoManager) var undoManager
    
    @State var project: Project
    @State var task: Task
    @State var mode: CRUDMode
    
    @State var update = false
    
    var body: some View {
        if update {}
        Form {
            if task.start != nil {
                DatePicker("Start", selection: Binding($task.start)!)
            }
            if task.end != nil {
                DatePicker("End", selection: Binding($task.end)!)
            } else {
                Button {
                    withAnimation {
                        task.end = Date().withoutSeconds()
                        viewContext.safeSave()
                        update.toggle()
                    }
                } label: {
                    Text("Finish")
                }
            }
            TextField("Description", text: Binding($task.desc, ""))
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
                    task.project = project
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
            undoManager?.registerUndo(withTarget: task, handler: { e in
                e.objectWillChange.send()
            })
        }
    }
}
