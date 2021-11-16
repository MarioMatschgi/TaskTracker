//
//  TaskDetailView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var task: Task
    @State var update = false
    @State var selected: TaskEntry? = nil
    
    var body: some View {
        if update { }
        VStack {
            Form {
                TextField("Name", text: Binding($task.name, ""), onCommit: {
                    viewContext.safeSave()
                })
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
                        VStack { }.frame(width: 52)
                    }
                    List(task.entriesArr, id: \.self, selection: $selected) { entry in
                        HStack {
                            Text(entry.toStringStart())
                                .frame(width: 55, alignment: .leading)
                            Text(entry.toStringEnd())
                                .frame(width: 55, alignment: .leading)
                            Spacer()
                            Text(DateTimeUtil.getTimeDiffFormatted(entry.start!, entry.end))
                            Button {
                                print("EDIT")
                            } label: {
                                Image(systemName: "pencil")
                            }.buttonStyle(PlainButtonStyle())
                            Button {
                                removeItem(entry)
                            } label: {
                                Image(systemName: "trash")
                            }.buttonStyle(PlainButtonStyle())
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
    }
    
    func removeItem(_ entry: TaskEntry) {
        withAnimation {
            viewContext.delete(entry)
            
            update.toggle()
            viewContext.safeSave()
        }
    }
}
