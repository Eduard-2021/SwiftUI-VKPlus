//
//  Friends+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//
//

import SwiftUI
import CoreData


extension Friends {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friends> {
        return NSFetchRequest<Friends>(entityName: "FriendEntity")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var idUser: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var userAvatar: UIImage?
    @NSManaged public var userAvatarURL: String?

}

extension Friends : Identifiable {

}
