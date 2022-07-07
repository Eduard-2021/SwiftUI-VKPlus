//
//  GroupEntity+CoreDataClass.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 25.10.2021.
//
//

import Foundation
import CoreData

@objc(GroupEntity)
public class GroupEntity: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, group: VKGroup) {
        self.init(context: context)
        self.groupAvatar = group.groupAvatar
        self.id = group.id
        self.idGroup = Int64(group.idGroup)
        self.imageGroupURL = group.imageGroupURL
        self.nameGroup = group.nameGroup
    }
}
