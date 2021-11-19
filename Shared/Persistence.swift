//
//  Persistence.swift
//  Shared
//
//  Created by Mario Elsnig on 16.11.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TaskTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.undoManager = UndoManager()
    }
}

extension Task {
    static var taskFetchRequest: NSFetchRequest<Task> {
        let request = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
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

extension Model: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let tasks = controller.fetchedObjects as? [Task]
      else { return }

      self.tasks = tasks
  }
}
