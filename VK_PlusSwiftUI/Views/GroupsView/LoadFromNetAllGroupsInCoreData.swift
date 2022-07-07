//
//  LoadFromNetAllGroupsInCoreData.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 25.10.2021.
//

import SwiftUI
import CoreData

class LoadFromNetAllGroupsInCoreData: ObservableObject {
    @Published var groupsVK = [VKGroup]()
    let mainNetworkService = MainNetworkService()
    
    func load(fetchedGroups: FetchedResults<GroupEntity>, managedObjectContext: NSManagedObjectContext) {
        
        mainNetworkService.getGroupsOfUser(userId: DataAboutSession.data.userID) { (groups) in
            guard var groups = groups else {return}
            for (index, value) in groups.enumerated() {
                self.mainNetworkService.getPhotoFromNet(url: value.imageGroupURL) {(image) in
                    guard let image = image else {return}
                    groups[index].groupAvatar = image
                    if groups.first(where: {$0.groupAvatar == nil}) == nil {
                        self.loadingInCoreData(groups: groups, managedObjectContext: managedObjectContext, fetchedGroups: fetchedGroups)
//                        self.groupsVK = groups
                    }
                }
            }
        }
    }
    
    
    private func loadingInCoreData(groups: [VKGroup], managedObjectContext: NSManagedObjectContext,  fetchedGroups: FetchedResults<GroupEntity>) {
        
//        ClearContainerCoreData.deleteAll(managedObjectContext: managedObjectContext, fetchedEntity: fetchedGroups)
        
        var newGroupsVK = [VKGroup]()
        
        if !fetchedGroups.isEmpty {
            for group in groups {
                if (fetchedGroups.first(where: {$0.idGroup == group.idGroup}) == nil) {
                    newGroupsVK.append(group)
                }
            }
        } else {
            newGroupsVK = groups
        }
        
        if !newGroupsVK.isEmpty {
            var _ = newGroupsVK.map {GroupEntity(context: managedObjectContext, group: $0)}
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

