//
//  LoadFromNetAllPhotosInCoreData.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//

import SwiftUI
import CoreData

class LoadFromNetAllPhotosInCoreData {
    var photosVK = [OnePhotoOfFriendOptimalSize]()
    let mainNetworkService = MainNetworkService()
    
    func load(fetchFriend: FriendEntity, managedObjectContext: NSManagedObjectContext) {
      
        mainNetworkService.getAllPhotos(userId: String((fetchFriend.idUser))) { (photos) in
            guard var photos = photos else {return}
            for (index, value) in photos.enumerated() {
                self.mainNetworkService.getPhotoFromNet(url: value.imageURL) {(image) in
                    guard let image = image else {return}
                    photos[index].userPhoto = image
                    if photos.first(where: {$0.userPhoto == nil}) == nil {
                        self.loadingInCoreData(photosVK: photos, managedObjectContext: managedObjectContext, fetchedFriend: fetchFriend)
                    }
                }
            }
        }
    }
    
    private func loadingInCoreData(photosVK: [OnePhotoOfFriendOptimalSize], managedObjectContext: NSManagedObjectContext,  fetchedFriend: FriendEntity) {
        

        var newphotosVK = [OnePhotoOfFriendOptimalSize]()
        
        if let allPhotosFriend = fetchedFriend.allPhotosFriend?.allObjects as? [FriendPhotoOptimalSizeEntity] {
            for photo in photosVK {
                if (allPhotosFriend.first(where: {$0.serialNumberPhoto == photo.serialNumberPhoto}) == nil) || allPhotosFriend.isEmpty {
                    newphotosVK.append(photo)
                }
            }
        }
    
        if !newphotosVK.isEmpty {
            var _ = newphotosVK.map {FriendPhotoOptimalSizeEntity(context: managedObjectContext, photo: $0, friend: fetchedFriend)}
        }

        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch let error {
                print(error)
            }
        }
    }
    
}
