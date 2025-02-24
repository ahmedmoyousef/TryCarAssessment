//
//  CoreDataStack.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TryCarAssessment")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
} 
