//
//  DataController.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

class DataController {
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }

    // to be used in the extension to create notifications
    var notificationManager = NotificationManager()

    static let preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("🔥Fata error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading stores. \(error)")
            }
        }
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("🔥 Error saving: \(error)")
            }
        }
    }

    func delete(_ object: NSManagedObject?) {
        if let object = object {
            context.delete(object)
        }
    }

    // for testing
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Reminder.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        _ = try? context.execute(batchDeleteRequest)

//        // we can't simply save() because the batchDeleteRequest runs on the underlying sqlite database
//        // if we just save(), the data in the UI will not update until we restart the app, but reset() forces
//        // the viewContext to reload its data from the sqlite database
        context.reset()
    }

    // NOT USED YET
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? context.count(for: fetchRequest)) ?? 0
    }

}
