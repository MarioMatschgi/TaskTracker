//
//  HomeView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

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
                    Text(task.name!)
                    Spacer()
                    Image(systemName: task.isTracking ? "stop.circle" : "play.fill")
                }.tag(task)
            }
        }
        .navigationTitle(selected?.name ?? "")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
