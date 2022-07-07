//
//  FriendEntity+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 24.10.2021.
//
//

import SwiftUI
import CoreData


extension FriendEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendEntity> {
        return NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var idUser: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var userAvatar: UIImage?
    @NSManaged public var userAvatarURL: String?
    @NSManaged public var allPhotosFriend: NSSet?

}

// MARK: Generated accessors for allPhotosFriend
extension FriendEntity {

    @objc(addAllPhotosFriendObject:)
    @NSManaged public func addToAllPhotosFriend(_ value: FriendPhotoOptimalSizeEntity)

    @objc(removeAllPhotosFriendObject:)
    @NSManaged public func removeFromAllPhotosFriend(_ value: FriendPhotoOptimalSizeEntity)

    @objc(addAllPhotosFriend:)
    @NSManaged public func addToAllPhotosFriend(_ values: NSSet)

    @objc(removeAllPhotosFriend:)
    @NSManaged public func removeFromAllPhotosFriend(_ values: NSSet)

}

extension FriendEntity : Identifiable {

}
