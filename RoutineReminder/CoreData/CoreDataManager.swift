//
//  CoreDataManager.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    let container: NSPersistentCloudKitContainer
    var context: NSManagedObjectContext { container.viewContext }

    static let preview: CoreDataManager = {
        let dataController = CoreDataManager(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fata error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading stores. \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }

    // TODO: implement function //
    // for testing
    func deleteAll() {
//        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
//        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
//        _ = try? container.viewContext.execute(batchDeleteRequest1)
//
//        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
//        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
//        _ = try? container.viewContext.execute(batchDeleteRequest2)
//
//        // we can't simply save() because the batchDeleteRequest runs on the underlying sqlite database
//        // if we just save(), the data in the UI will not update until we restart the app, but reset() forces
//        // the viewContext to reload its data from the sqlite database
//        container.viewContext.reset()
    }

    // TODO: Check at the end if not needed remove it
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? context.count(for: fetchRequest)) ?? 0
    }

}
