//
//  FriendEntity+CoreDataClass.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//
//

import Foundation
import CoreData

@objc(FriendEntity)
public class FriendEntity: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, user: VKUser) {
        self.init(context: context)
        self.idUser = Int64(user.idUser)
        self.lastName = user.lastName
        self.fullName = user.fullName
        self.userAvatarURL = user.userAvatarURL
        self.userAvatar = user.userAvatar
        self.id = user.id
        self.firstName = user.firstName
    }

}
