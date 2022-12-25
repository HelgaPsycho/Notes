//
//  DataStoreManager.swift
//  Notes
//
//  Created by Ольга Егорова on 23.12.2022.
//

import Foundation
import CoreData

class DataStoreManager {
    let delegate = AppDelegate()
    
    static var subscribers: [Subscriber] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
               // fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var mainViewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var noteEditContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
        }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch{
                context.rollback()
                let nserror = error as Error
                fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
            }
            
        }
        
        notifySuscribers()
    }
    
    func obtainNotes() throws -> [Note] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        if let notes = try mainViewContext.fetch(fetchRequest) as? [Note],
           !notes.isEmpty{
            return notes
        } else {
            throw DataStoreManagerErrors.emptyDataBase
        }
    }
    
    func obtainFavoriteNotes() throws -> [Note] {
        let favorites = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "favorites = true", favorites as CVarArg)
        
        if let notes = try mainViewContext.fetch(fetchRequest) as? [Note],
           !notes.isEmpty {
            return notes
        } else {
            throw DataStoreManagerErrors.emptyDataBase
        }
    }
    
    func obtainNote(dateOfCreation: Date) throws -> Note {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "dateOfCreation = %@", dateOfCreation as CVarArg)
        
        if let notes = try mainViewContext.fetch(fetchRequest) as? [Note],
           !notes.isEmpty {
            let note = notes.first
            
            return note!
        } else {
            throw DataStoreManagerErrors.emptyDataBase
        }
    }
    
    func deleteNote(note: Note) {
        mainViewContext.delete(note)
        
        try? mainViewContext.save()
    }
    
}

// MARK: - DataStoreManagerErrors -
enum DataStoreManagerErrors: Error {
    case emptyDataBase
    case cantSaveDelete
}
