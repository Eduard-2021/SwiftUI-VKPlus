//
//  SaveNewGroupInCoreData.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 25.10.2021.
//

import CoreData

class SaveAndDeleteGroupInCoreData {
    func save(newGroup: VKGroup, managedObjectContext: NSManagedObjectContext) {
        
        GroupEntity(context: managedObjectContext, group: newGroup)
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(groupForDelete: GroupEntity, managedObjectContext: NSManagedObjectContext) {
        
       managedObjectContext.delete(groupForDelete)
   
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
