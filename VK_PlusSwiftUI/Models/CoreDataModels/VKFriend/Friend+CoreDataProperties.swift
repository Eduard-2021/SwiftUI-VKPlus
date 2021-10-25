//
//  Friend+CoreDataProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var idUser: Int64
    @NSManaged public var userAvatarURL: String?

}

extension Friend : Identifiable {

}
