//
//  ClearContainerCoreData.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 24.10.2021.
//

import SwiftUI
import CoreData

class ClearContainerCoreData {
    class func deleteAll<T>(managedObjectContext: NSManagedObjectContext,  fetchedEntity: FetchedResults<T>){
        
        for element in fetchedEntity {
            managedObjectContext.delete(element as! NSManagedObject)
        }
    }
}

