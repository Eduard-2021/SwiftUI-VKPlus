//
//  FriendEntity+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//
//

import SwiftUI
import CoreData


extension FriendEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendEntity> {
        return NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var userAvatarURL: String?
    @NSManaged public var userAvatar: UIImage?
    @NSManaged public var idUser: Int64
    @NSManaged public var id: UUID?

}

extension FriendEntity : Identifiable {

}
