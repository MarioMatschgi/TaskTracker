//
//  TrackTaskView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

/// View that shows the current time for the given task with options to start/stop tracking
struct TrackTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var task: Task?
    @State var update = false
    
    @State var timer: Timer? = nil
    
    var body: some View {
        if update { }
        if task == nil {
            Text("Select a Task to track")
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(task?.name ?? "")
                    Text(getFullDuration())
                    if task!.entriesArr.count > 0 {
                        Text(DateTimeUtil.getTimeDiffFormatted(task!.entriesArr[0].start!, task!.entriesArr[0].end))
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    toggleTracking()
                } label: {
                    Image(systemName: task!.isTracking ? "stop.circle" : "play.fill")
                        .resizable()
                }
                .keyboardShortcut(.space, modifiers: [])
                .buttonStyle(BorderlessButtonStyle())
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: .infinity)
                
                VStack(alignment: .trailing) {
                    ForEach(task!.entriesArr.prefix(3), id: \.self) { entry in
                        Text(entry.toString())
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding()
            .onAppear {
                if task!.isTracking {
                    startTimer()
                }
            }
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
            if task!.isTracking {
                if task!.entriesArr.count > 0 {
                    task?.entriesArr[0].end = Date()
                }
                stopTimer()
            } else {
                let new = TaskEntry(context: viewContext)
                new.start = Date().addingTimeInterval(-1 * TimeInterval(Double(Date().timeIntervalSince1970.millisecond) / Double(1000)))
                new.task = task!
                startTimer()
            }
            
//            for e in Array(task!.entries! as! Set<TaskEntry>) {
//                viewContext.delete(e)
//            }
            
            task!.isTracking = !task!.isTracking
            
            update.toggle()
            viewContext.safeSave()
        }
    }
    
    func getFullDuration() -> String {
        var diff = TimeInterval()
        for entry in task!.entriesArr {
            diff += entry.start!.distance(to: entry.end ?? Date())
        }
        return diff.diffString
    }
}
