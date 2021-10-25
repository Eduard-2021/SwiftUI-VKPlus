//
//  GroupEntity+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 25.10.2021.
//
//

import SwiftUI
import CoreData


extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var groupAvatar: UIImage?
    @NSManaged public var id: UUID?
    @NSManaged public var idGroup: Int64
    @NSManaged public var imageGroupURL: String?
    @NSManaged public var nameGroup: String?

}

extension GroupEntity : Identifiable {

}
