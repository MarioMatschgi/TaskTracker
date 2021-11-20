//
//  ContentView.swift
//  Shared
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var page: PageType? = .home

    var body: some View {
        NavigationView {
            List {
                NavigationLink(tag: .home, selection: $page) {
                    HomeView()
                } label: {
                    Label("Home", systemImage: "house.fill")
                }
                NavigationLink(tag: .track, selection: $page) {
                    TaskView()
                } label: {
                    Label("Tasks", systemImage: "square.and.pencil")
                }
                NavigationLink(tag: .history, selection: $page) {
                    HistoryView()
                } label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }.listStyle(SidebarListStyle())
        }
    }
}
