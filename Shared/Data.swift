//
//  Data.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import Foundation
import SwiftUI

enum PageType {
    case home
    case track
    case history
}

class Model: NSObject, ObservableObject {
    // Thanks to https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
    @Published var tasks: [Task] = []
    
    private let controller: NSFetchedResultsController<Task>

      init(managedObjectContext: NSManagedObjectContext) {
          controller = NSFetchedResultsController(fetchRequest: Task.taskFetchRequest,
        managedObjectContext: managedObjectContext,
        sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        controller.delegate = self

        do {
          try controller.performFetch()
            tasks = controller.fetchedObjects ?? []
        } catch {
          print("failed to fetch items!")
        }
      }
}

extension Task {
    static var taskFetchRequest: NSFetchRequest<Task> {
        let request = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
}

extension Model: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let tasks = controller.fetchedObjects as? [Task]
      else { return }

      self.tasks = tasks
  }
}
