//
//  LoadNews.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 10.10.2021.
//

import SwiftUI

class LoadNews: ObservableObject {
    @Published var newsVK = [OneNews]()
    @Published var nearLastElementInArrayOfNews = false
    @Published var needDownloadLastNews = false
    @Published var heightCellWithPhotoOfNewsView: CGFloat = 0
    
    let mainNetworkService = MainNetworkService()
    
    private let currentTime = Date().timeIntervalSince1970
    private let durationOneDay : Double = 60*60*24
    private var nextGroupNews = ""
    
    func load(isRefresh: Bool) {
        var startTime = currentTime - durationOneDay
        var endTime = currentTime - 1800 // смещение по времени на 30 минут чтобы протестить PullRefresh
        var nextGroupNewsForAllDownload = nextGroupNews
        
        if isRefresh {
            startTime = newsVK.first!.date + 1
            endTime = currentTime
            nextGroupNewsForAllDownload = ""
        }
            
        mainNetworkService.getNews(startTime: startTime, endTime: endTime, nextGroup: nextGroupNewsForAllDownload) { [weak self] (vkResponseItems,vkResponseProfilesUsers,vkResponseProfilesGroups, vkResponseNextGroup) in
            guard var itemsVKUnwrapped = vkResponseItems?.response.items,
                  let profilesVKUsersUnwrapped = vkResponseProfilesUsers,
                  let profilesVKGroupsUnwrapped = vkResponseProfilesGroups,
                  let self=self
            else {return}
            
            if !isRefresh {
                guard let nextGroup = vkResponseNextGroup else {return}
                self.nextGroupNews = nextGroup.response.nextGroupFrom
            }
            
            let profilesVKUsers = profilesVKUsersUnwrapped.response.profiles
            let profilesVKGroups = profilesVKGroupsUnwrapped.response.groups
            
            DispatchQueue.main.async {
                itemsVKUnwrapped = itemsVKUnwrapped.filter({$0.attachments.first(where: {$0.type == "photo"}) !=  nil})
            }
            
            DispatchQueue.main.async {
                self.calcNumberRowsAndPhotosInEachRowInAttachment(itemsVKUnwrapped: itemsVKUnwrapped) { (items) in
                    self.loadPhoto(isRefresh: isRefresh, itemsVKUnwrapped: items, profilesVKUsers: profilesVKUsers, profilesVKGroups: profilesVKGroups)
                }
            }
//                self.calculateTextHeight(from: 0, to: newsVK.count-1)

            }
    }
    
    
    //MARK: Load all photos
    private func loadPhoto(isRefresh: Bool, itemsVKUnwrapped: [OneNews], profilesVKUsers: [OneVKProfiles], profilesVKGroups: [VKGroup]){
        var newsVKWithAvatarAndPhotos = itemsVKUnwrapped
        let dispatchGroup = DispatchGroup()
        var usersOfNews = [VKUser]()
        var groupsOfNews = [VKGroup]()
//        var nowDownloadedArrayOfNewsVK = itemsVKUnwrapped
        
        for (indexInNewsVK, oneNews) in newsVKWithAvatarAndPhotos.enumerated() {

            if oneNews.numberPhotoInAttachement != 0 {
                for value in oneNews.attachments {
                    if value.type == "photo" {
                        dispatchGroup.enter()
                        var numberPhotosInRow = 0
                        _ = oneNews.numberPhotosInEachRow.reduce(0) {(result, valueInReduce) in
                            if (result+valueInReduce >= indexInNewsVK+1) && (numberPhotosInRow == 0) {
                                numberPhotosInRow = valueInReduce
                            }
                            return result+valueInReduce
                        }
                        let sizes = value.attachmentVKPhoto.photo.sizes
                        var photoWithOptimalSize = SizeVKNewsPhoto()
                        switch numberPhotosInRow {
                            case 1:
                                photoWithOptimalSize = sizes.first(where: {$0.width>600}) ?? sizes.last!
                            case 2:
                                photoWithOptimalSize = sizes.first(where: {$0.width>300}) ?? sizes.last!
                            case 3:
                                photoWithOptimalSize = sizes.first(where: {$0.width>200}) ?? sizes.last!
                            default:
                                photoWithOptimalSize = sizes.last!
                        }
                        
                        mainNetworkService.getPhotoFromNet(url: photoWithOptimalSize.url) { (image) in
                                guard let image = image else {return}
                                newsVKWithAvatarAndPhotos[indexInNewsVK].arrayOfLargestPhotosOfNews.append(image)
                                dispatchGroup.leave()
                            }
                    }
                }
            }
        }
        
        dispatchGroup.enter()
        self.loadGroupsAndUsersForNews(profilesVKUsers: profilesVKUsers, profilesVKGroups: profilesVKGroups) {
            (usersOfNewsForReturn,groupsOfNewsForReturn) in
            usersOfNews = usersOfNewsForReturn
            groupsOfNews = groupsOfNewsForReturn
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [self] in
            newsVKWithAvatarAndPhotos = newsVKWithAvatarAndPhotos.map {(oneNews) -> OneNews in
                var oneNewsResult = oneNews
                if let currentUser = usersOfNews.first(where: {$0.idUser == abs(oneNews.sourceID)}) {
                    oneNewsResult.newsUserVK = currentUser
                }
                return oneNewsResult
            }
            
            newsVKWithAvatarAndPhotos = newsVKWithAvatarAndPhotos.map {(oneNews) -> OneNews in
                var oneNewsResult = oneNews
                if let currentGroup = groupsOfNews.first(where: {$0.idGroup == abs(oneNews.sourceID)}) {
                    oneNewsResult.newsGroupVK = currentGroup
                }
                return oneNewsResult
            }
            
            if isRefresh {
                needDownloadLastNews = false
                newsVK = newsVKWithAvatarAndPhotos + newsVK
            }
            else {
                newsVK.append(contentsOf: newsVKWithAvatarAndPhotos)
            }
            if nearLastElementInArrayOfNews {
                nearLastElementInArrayOfNews = false
            }
        }
    }
    
    
    private func calcNumberRowsAndPhotosInEachRowInAttachment(itemsVKUnwrapped: [OneNews], completion: @escaping ([OneNews]) -> Void)  {
        
        var nowDownloadedArrayOfNewsVK = itemsVKUnwrapped
        
        func calculatingNumberPhotoInAttachment() {
            for (index, oneNews) in nowDownloadedArrayOfNewsVK.enumerated() {
                var numberPhoto = 0
                for value in oneNews.attachments {
                    if value.type == "photo" {
                        numberPhoto += 1
                    }
                }
                nowDownloadedArrayOfNewsVK[index].numberPhotoInAttachement = numberPhoto
            }
        }
        
        func calculatingNumberRowsInAttachment() {
            for (index, oneNews) in nowDownloadedArrayOfNewsVK.enumerated() {
                switch oneNews.numberPhotoInAttachement {
                    case 0:
                        continue
                    case 1,2:
                        nowDownloadedArrayOfNewsVK[index].numberRowsForPhotoInAttachement = 1
                        continue
                    case 3:
                        nowDownloadedArrayOfNewsVK[index].numberRowsForPhotoInAttachement = 2
                        continue
                    default:
                        nowDownloadedArrayOfNewsVK[index].numberRowsForPhotoInAttachement = oneNews.numberPhotoInAttachement/2
                }
            }
        }
        
        func calculatingNumberPhotosInRow(){
            for (index, oneNews) in nowDownloadedArrayOfNewsVK.enumerated() {
                var numberPhotosInRow = [Int]()
                var numberPostedPhotoInPreviousRows = [Int]()
                var sizePhotosInRows = [CGFloat]()
                var numberPostedPhoto = 0
                if oneNews.numberRowsForPhotoInAttachement != 0 {
                    
                     let heightOnePhoto = CGFloat(oneNews.attachments[oneNews.attachments.firstIndex(where: {$0.type == "photo"})!].attachmentVKPhoto.photo.sizes.first!.height / oneNews.attachments[oneNews.attachments.firstIndex(where: {$0.type == "photo"})!].attachmentVKPhoto.photo.sizes.first!.width) * UIScreen.main.bounds.width
                    
                    heightCellWithPhotoOfNewsView = heightOnePhoto * 1.7
 
                    for i in 1...oneNews.numberRowsForPhotoInAttachement {
                        switch i {
                            case 1:
                                switch oneNews.numberPhotoInAttachement {
                                    case 1:
                                        numberPhotosInRow.append(1)
                                        numberPostedPhotoInPreviousRows.append(0)
                                        sizePhotosInRows.append(UIScreen.main.bounds.width-20)
                                        heightCellWithPhotoOfNewsView = heightOnePhoto
                                    case 2:
                                        numberPhotosInRow.append(2)
                                        numberPostedPhotoInPreviousRows.append(0)
                                        sizePhotosInRows.append(UIScreen.main.bounds.width/2-10)
                                        heightCellWithPhotoOfNewsView = heightOnePhoto / 2
                                    case 3:
                                        break
                                    default:
                                        numberPhotosInRow.append(3)
                                        numberPostedPhotoInPreviousRows.append(0)
                                        sizePhotosInRows.append(UIScreen.main.bounds.width/3-10)
                                    }
                            case 2:
                                if oneNews.numberPhotoInAttachement == 3 {
                                    numberPhotosInRow.append(2)
                                    numberPostedPhotoInPreviousRows.append(1)
                                    sizePhotosInRows.append(UIScreen.main.bounds.width/2-10)
                                    heightCellWithPhotoOfNewsView = heightOnePhoto * 1.6
                                }
                                else
                                    if oneNews.numberPhotoInAttachement == 5 {
                                        numberPhotosInRow.append(2)
                                        numberPostedPhotoInPreviousRows.append(3)
                                        sizePhotosInRows.append(UIScreen.main.bounds.width/2-10)
                                        heightCellWithPhotoOfNewsView = heightOnePhoto * 1.6
                                    }
                                else {
                                    numberPhotosInRow.append(1)
                                    numberPostedPhoto = 4
                                    numberPostedPhotoInPreviousRows.append(numberPostedPhoto-1)
                                    sizePhotosInRows.append(UIScreen.main.bounds.width-20)
                                    heightCellWithPhotoOfNewsView = heightOnePhoto * 1.4
                                }
                            case oneNews.numberRowsForPhotoInAttachement:
                                if oneNews.numberPhotoInAttachement > 5 {
                                    numberPostedPhotoInPreviousRows.append(numberPostedPhoto)
                                    numberPhotosInRow.append(oneNews.numberPhotoInAttachement - numberPostedPhoto)
                                    sizePhotosInRows.append(UIScreen.main.bounds.width/CGFloat((numberPhotosInRow.last ?? 1))-10)
                                    
                        
                                }
                        
                            default:
                                if (i % 2 == 0) {
                                    numberPostedPhotoInPreviousRows.append(numberPostedPhoto)
                                    numberPostedPhoto += 1
                                    numberPhotosInRow.append(1)
                                    sizePhotosInRows.append(UIScreen.main.bounds.width-10)
                                }
                                else {
                                    numberPostedPhotoInPreviousRows.append(numberPostedPhoto)
                                    numberPostedPhoto += 3
                                    numberPhotosInRow.append(3)
                                    sizePhotosInRows.append(UIScreen.main.bounds.width/3-10)
                                }
                            }
                    }
                }
                nowDownloadedArrayOfNewsVK[index].numberPhotosInEachRow = numberPhotosInRow
                nowDownloadedArrayOfNewsVK[index].numberPostedPhotoInPreviousRows = numberPostedPhotoInPreviousRows
                nowDownloadedArrayOfNewsVK[index].sizePhotosInRows = sizePhotosInRows
            }
        }
        
        calculatingNumberPhotoInAttachment()
        calculatingNumberRowsInAttachment()
        calculatingNumberPhotosInRow()
        completion(nowDownloadedArrayOfNewsVK)
    }
    
    // MARK: Load Avatar groups and Users
    private func loadGroupsAndUsersForNews(profilesVKUsers: [OneVKProfiles], profilesVKGroups: [VKGroup], completion: @escaping ([VKUser],[VKGroup]) -> Void) {
        
        let dispatchGroupForUsersAndGroups = DispatchGroup()
        let dispatchGroupForUsers = DispatchGroup()
        let dispatchGroupForGroups = DispatchGroup()
        var usersOfNewsForReturn = [VKUser]()
        var groupsOfNewsForReturn = [VKGroup]()
//        var nowDownloadedArrayOfNewsVK = itemsVKUnwrapped
        
        if !profilesVKUsers.isEmpty {
            let usersIDs = profilesVKUsers.reduce("") {result, value in
                return result + "," + "\(value.id)"
            }
            dispatchGroupForUsersAndGroups.enter()
            mainNetworkService.getUsersOfNews(usersIDs: usersIDs) { [weak self] vkResponse in
                guard let usersOfNews = vkResponse?.response else {return}
                usersOfNewsForReturn = usersOfNews
                
                for (index, value) in usersOfNews.enumerated() {
                    dispatchGroupForUsers.enter()
                    self!.mainNetworkService.getPhotoFromNet(url: value.userAvatarURL) { (image) in
                        guard let image = image else {return}
                        usersOfNewsForReturn[index].userAvatar = image
                        dispatchGroupForUsers.leave()
                    }
                }
                
                dispatchGroupForUsers.notify(queue: DispatchQueue.main) {
                    dispatchGroupForUsersAndGroups.leave()
                }
            }
        }
        
        if !profilesVKGroups.isEmpty {
            let groupsIDs = profilesVKGroups.reduce("") {result, value in
                return result + "," + "\(value.idGroup)"
            }
            dispatchGroupForUsersAndGroups.enter()
            mainNetworkService.getGroupsOfNews(groupsIDs: groupsIDs) { [weak self] vkResponse in
                guard let groupsOfNews = vkResponse?.response else {return}
                groupsOfNewsForReturn = groupsOfNews
                
                for (index, value) in groupsOfNews.enumerated() {
                    dispatchGroupForGroups.enter()
                    self!.mainNetworkService.getPhotoFromNet(url: value.imageGroupURL) {(image) in
                        guard let image = image else {return}
                        groupsOfNewsForReturn[index].groupAvatar = image
                        dispatchGroupForGroups.leave()
                    }
                }
                dispatchGroupForGroups.notify(queue: DispatchQueue.main) {
                    dispatchGroupForUsersAndGroups.leave()
                }
            }
        }
        dispatchGroupForUsersAndGroups.notify(queue: DispatchQueue.main) {
            completion(usersOfNewsForReturn,groupsOfNewsForReturn)
        }
    }
}
