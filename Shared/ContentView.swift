//
//  ContentView.swift
//  Shared
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var model: Model
    
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

    private func addItem() {
        withAnimation {
            let newItem = Task(context: viewContext)
            newItem.id = UUID()
            newItem.name = "New Task"
            newItem.entries = []

            viewContext.safeSave()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { model.tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
