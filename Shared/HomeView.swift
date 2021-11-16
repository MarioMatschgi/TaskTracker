//
//  HomeView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selected = 0 // ToDo: Change to the datatype of a task
    
    @State var tracking = false // ToDo: Remove and change occurences to use the value of selected task
    
    var body: some View {
//        Text("See what you currently track, start/stop tracking of existing tasks")
        VStack {
            VStack {
//                Text("Show current time for selected tast with option to start/stop tracking")
                HStack {
                    Button {
                        toggleTracking()
                    } label: {
                        Image(systemName: tracking ? "stop.circle" : "play.fill")
                            .resizable()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(width: 40, height: 40)
                }
                Text("5h 30min")
            }
            List {
                HStack {
                    Text("List of element to track, click to select")
                    Spacer()
                    Text("indicator if tracking or stopped")
                }.tag(0)
            }
        }
        .padding(.top)
        .navigationTitle("SELECTEDTASK")
    }
    
    func toggleTracking() {
        withAnimation {
            tracking.toggle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
