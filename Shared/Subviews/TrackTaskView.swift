//
//  TrackTaskView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// View that shows the current time for the given project with options to start/stop tracking a task
struct TrackProjectView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var project: Project?
    @State var update = false
    
    @State var timer: Timer? = nil
    @State var desc = ""
    
    var body: some View {
        if update { }
        if project == nil {
            Text("Select a Project to track")
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(project?.name ?? "")
                    Text("Total: " + (project?.getFullDuration() ?? "0s"))
                    if project!.tasksArr.count > 0 {
                        Text("Current: " + DateTimeUtil.getTimeDiffFormatted(project!.tasksArr[0].start!, project!.tasksArr[0].end))
                    } else {
                        Text("Current: 0s")
                    }
                    Form {
                        TextField("Task", text: $desc)
                    }.padding(.trailing, 15)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    toggleTracking()
                } label: {
                    Image(systemName: project!.isTracking ? "stop.circle" : "play.fill")
                        .resizable()
                }
                .keyboardShortcut(.space, modifiers: [])
                .buttonStyle(BorderlessButtonStyle())
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: .infinity)
                
                VStack(alignment: .trailing) {
                    ForEach(project!.tasksArr.prefix(4), id: \.self) { entry in
                        Text(entry.toString())
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding()
            .onAppear {
                if project!.isTracking {
                    startTimer()
                }
                desc = userDefaults.string(forKey: KEYS.HOME_PROJECT_DESC + project!.id!.uuidString) ?? ""
            }
            .onChange(of: project, perform: { newValue in
                desc = userDefaults.string(forKey: KEYS.HOME_PROJECT_DESC + newValue!.id!.uuidString) ?? ""
            })
            .onChange(of: desc, perform: { newValue in
                userDefaults.setValue(newValue, forKey: KEYS.HOME_PROJECT_DESC + project!.id!.uuidString)
            })
            .onDisappear {
                stopTimer()
            }
        }
    }
    
    func startTimer() {
        stopTimer()
        let waitFor = TimeInterval(Double(1000 - Date().timeIntervalSince1970.millisecond + 10) / Double(1000))
        _ = Timer.scheduledTimer(withTimeInterval: waitFor, repeats: false) { _ in
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                update.toggle()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func toggleTracking() {
        withAnimation {
            if project!.isTracking {
                if project!.tasksArr.count > 0 {
                    project?.tasksArr[0].end = Date().withoutSeconds()
                }
                stopTimer()
            } else {
                let new = Task(context: viewContext)
                new.start = Date().withoutSeconds()
                new.project = project!
                startTimer()
            }
            
            update.toggle()
            model.objectWillChange.send()
            viewContext.safeSave()
        }
    }
}
