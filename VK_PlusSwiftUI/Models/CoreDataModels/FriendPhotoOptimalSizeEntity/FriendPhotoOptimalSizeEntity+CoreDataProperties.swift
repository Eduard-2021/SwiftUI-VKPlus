//
//  FriendPhotoOptimalSizeEntity+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//
//

import SwiftUI
import CoreData


extension FriendPhotoOptimalSizeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendPhotoOptimalSizeEntity> {
        return NSFetchRequest<FriendPhotoOptimalSizeEntity>(entityName: "FriendPhotoOptimalSizeEntity")
    }

    @NSManaged public var idUser: Int64
    @NSManaged public var serialNumberPhoto: Int64
    @NSManaged public var idPhoto: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var numLikes: Int16
    @NSManaged public var i_like: Bool
    @NSManaged public var userPhoto: UIImage?
    @NSManaged public var sizeInGrid: CGRect?
    @NSManaged public var id: UUID?

}

extension FriendPhotoOptimalSizeEntity : Identifiable {

}
