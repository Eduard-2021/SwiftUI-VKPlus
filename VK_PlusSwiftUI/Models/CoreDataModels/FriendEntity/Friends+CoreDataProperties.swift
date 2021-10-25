//
//  Friends+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//
//

import SwiftUI
import CoreData


extension Friends {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friends> {
        return NSFetchRequest<Friends>(entityName: "Friends")
    }

    @NSManaged public var idUser: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var fullName: String? {self.lastName + " " + self.firstName}
    @NSManaged public var userAvatarURL: String?
    @NSManaged public var userAvatar: UIImage?
    @NSManaged public var id: UUID?

}

extension Friends : Identifiable {

}
