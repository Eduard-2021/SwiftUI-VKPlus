//
//  LoadFromNetInCoreData.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//

import SwiftUI
import CoreData

class LoadFriends: ObservableObject {
    var usersVK = [VKUser]()
    let mainNetworkService = MainNetworkService()
    
    func load(managedObjectContext: NSManagedObjectContext, fetchedFriends: FetchedResults<FriendEntity>) {
        mainNetworkService.getUserFriends() { (users) in
            guard var users = users else {return}
            for (index, value) in users.enumerated() {
                self.mainNetworkService.getPhotoFromNet(url: value.userAvatarURL) {(image) in
                    guard let image = image else {return}
                    users[index].userAvatar = image
                    users[index].fullName = users[index].lastName + " " + users[index].firstName
                    if !users.contains(where: {$0.userAvatar == nil}) {
                        users = users.sorted(by: {$0.fullName < $1.fullName})
                        self.loadingInCoreData(users: users, managedObjectContext: managedObjectContext, fetchedFriends: fetchedFriends)
                    }
                }
            }
        }
    }
    
    private func loadingInCoreData(users: [VKUser], managedObjectContext: NSManagedObjectContext,  fetchedFriends: FetchedResults<FriendEntity>) {
        
//        ClearContainerCoreData.deleteAll(managedObjectContext: managedObjectContext, fetchedEntity: fetchedFriends)

        var newUsers = [VKUser]()
        
        for user in users {
            if (fetchedFriends.first(where: {$0.idUser == user.idUser}) == nil) || (fetchedFriends.isEmpty) {
                newUsers.append(user)
            }
        }
        
        if !newUsers.isEmpty {
            var _ = newUsers.map {FriendEntity(context: managedObjectContext, user: $0)}
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
