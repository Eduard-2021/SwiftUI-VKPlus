//
//  CoreDataService.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//

import CoreData
import  SwiftUI

class CoreDataService: ObservableObject {
    
    internal init(modelName: String) {
        self.modelName = modelName
    }
    var context: NSManagedObjectContext { storeContainer.viewContext }
    
    let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
}


extension NSManagedObjectContext: ObservableObject {}
