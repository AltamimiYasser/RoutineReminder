//
//  ReminderListViewModel.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

// public typealias Codable = Decodable & Encodable
class ReminderListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var reminders = [Reminder]()

    let dataController: DataController
    let fetchController: NSFetchedResultsController<Reminder>

    init(dataController: DataController) {
        self.dataController = dataController

        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let context = dataController.context

        fetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        fetchController.delegate = self
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newReminders = controller.fetchedObjects as? [Reminder] {
            reminders = newReminders
        }
    }
}
