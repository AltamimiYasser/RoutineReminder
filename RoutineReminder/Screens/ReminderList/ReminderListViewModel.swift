//
//  ReminderListViewModel.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension RemindersListView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var reminders = [Reminder]()

        let dataController: DataController
        let fetchController: NSFetchedResultsController<Reminder>

        init(dataController: DataController) {
            self.dataController = dataController

            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.title, ascending: true)]

            let context = dataController.context

            fetchController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            fetchController.delegate = self
            getProjects()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newReminders = controller.fetchedObjects as? [Reminder] {
                reminders = newReminders
            }
        }

        // for testing
        func generateSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func getProjects() {
            do {
                try fetchController.performFetch()
                reminders = fetchController.fetchedObjects ?? []
            } catch {
                print("🔥 Error fetching results \(error)")
            }
        }
    }
}
