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

    let notificationManager = NotificationManager.shared

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

    func delete(_ object: NSManagedObject?, type: Reminder.TypeOfReminderData) {
        if let object = object {
            let id = object.objectID.uriRepresentation().absoluteString
            notificationManager.deleteNotifications(withID: [id], type: type)
            context.delete(object)
            save()
        }
    }
}
