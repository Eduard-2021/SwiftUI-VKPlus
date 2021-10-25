//
//  FriendPhotoOptimalSizeEntity+CoreDataClass.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//
//

import Foundation
import CoreData

@objc(FriendPhotoOptimalSizeEntity)
public class FriendPhotoOptimalSizeEntity: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, photo: OnePhotoOfFriendOptimalSize, friend: FriendEntity) {
        self.init(context: context)
        self.heightInGrid = photo.heightInGrid
        self.i_like = photo.i_like
        self.id = photo.id
        self.idPhoto = Int64(photo.idPhoto)
        self.idUser = Int64(photo.idUser)
        self.imageURL = photo.imageURL
        self.numLikes = Int16(photo.numLikes)
        self.serialNumberPhoto = Int64(photo.serialNumberPhoto)
        self.userPhoto = photo.userPhoto
        self.friend = friend
    }
}
