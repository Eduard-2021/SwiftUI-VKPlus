//
//  MainNetworkService.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

import SwiftUI

final class MainNetworkService {
    static let photoTest = UIImageView()
    
    private let apiVersion = "5.130"
    private let dispGroup = DispatchGroup()
   
    
    func makeComponents(for path: PathOfMethodsVK) -> URLComponents {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/\(path.rawValue)"
            url.queryItems = [
                URLQueryItem(name: "access_token", value: DataAboutSession.data.token),
                URLQueryItem(name: "v", value: apiVersion),
            ]
            return url
        }()
        return urlComponent
    }
    
    
    func getUserFriends(completion: @escaping ([VKUser]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getFriends)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "fields", value: "photo_200"),
        ])

        guard let url = urlComponents.url else {return}

        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<VKFriends>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}

                let allFriends = vkResponses.response.items
                
                DispatchQueue.main.async {
                    completion(allFriends)
                }
            }
        }
        .resume()
    }
    
    
    func getPhotoFromNet(url: String, completion: @escaping (UIImage?) -> Void) {
            
            let imageURL = URL(string: url)!

            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data)
                            else {
                                return
                            }
                        completion(image)
                        }
                    }
            }).resume()
    }

    
    func getAllPhotos(userId:String, completion: @escaping ([OnePhotoOfFriendOptimalSize]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getAllPhotos)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "owner_id", value: "\(userId)")
        ])
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<AllPhotoOfFriend>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}
                
                let allPhotosOfFriends = vkResponses.response.items.map {OnePhotoOfFriendOptimalSize(
                    idUser: $0.idUser,
                    serialNumberPhoto: 0,
                    idPhoto: $0.idPhoto,
                    imageURL: $0.differentSize.first(where: { (400..<650).contains($0.width) })?.url ?? "",
                    numLikes: $0.allLikes.count,
                    i_like: $0.allLikes.userLikes == 1
                    )
                }
                DispatchQueue.main.async {
                    completion(allPhotosOfFriends)
                }
            }
        }
        .resume()
    }
        
   
    func getGroupsOfUser(userId:Int, completion: @escaping ([VKGroup]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getGroupsUser)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "user_id", value: "\(userId)")
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<ActiveAndFoundGroups>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}
                
                let activeGroups = vkResponses.response.items
                DispatchQueue.main.async {
                    completion(activeGroups)
                }
            }
        }
        .resume()
    }
    
    
    func groupsSearch (textForSearch : String, numberGroups: Int, completion: @escaping ([VKGroup]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .groupsSearch)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "q", value: textForSearch),
            URLQueryItem(name: "count", value: "\(numberGroups)")
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<ActiveAndFoundGroups>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}
                
                let allSearchedGroups = vkResponses.response.items
                DispatchQueue.main.async {
                    completion(allSearchedGroups)
                }
            }
        }
        .resume()
    }
    
    func getNews(startTime: Double, endTime: Double = Date().timeIntervalSince1970, nextGroup: String = "", completion: @escaping (
                    VKResponseDecodable<VKNewsItems>?,
                    VKResponse<VKNewsProfilesUsers>?,
                    VKResponse<VKNewsProfilesGroups>?,
                    VKResponse<VKNextGroupOfNews>?) -> Void) {
        
        var vkResponseNewsItems : VKResponseDecodable<VKNewsItems>? = nil
        var vkResponseNewsProfilesUsers : VKResponse<VKNewsProfilesUsers>? = nil
        var vkResponseNewsProfilesGroups : VKResponse<VKNewsProfilesGroups>? = nil
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getNews)
        
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "end_time", value: "\(endTime)"),
            URLQueryItem(name: "count", value: "6"),
        ])
        if nextGroup != "" {
            urlComponents.queryItems?.append(contentsOf: [URLQueryItem(name: "start_from", value: "\(nextGroup)")])
        }
        else {
            urlComponents.queryItems?.append(contentsOf: [URLQueryItem(name: "start_time", value: "\(startTime)")])
        }
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) {(data, response, error) in
            if let data = data {
                DispatchQueue.global().async(group: self.dispGroup) {
                    vkResponseNewsItems = try? JSONDecoder().decode(VKResponseDecodable<VKNewsItems>.self, from: data)
                }
                
                DispatchQueue.global().async(group: self.dispGroup) {
                    vkResponseNewsProfilesUsers = try? JSONDecoder().decode(VKResponse<VKNewsProfilesUsers>.self, from: data)
                }
                
                DispatchQueue.global().async(group: self.dispGroup) {
                    vkResponseNewsProfilesGroups = try? JSONDecoder().decode(VKResponse<VKNewsProfilesGroups>.self, from: data)
                }
                
                let nextGroupFrom = try? JSONDecoder().decode(VKResponse<VKNextGroupOfNews>.self, from: data)
                
                self.dispGroup.notify(queue: .main) {
                    completion(vkResponseNewsItems,
                               vkResponseNewsProfilesUsers,
                               vkResponseNewsProfilesGroups,
                               nextGroupFrom)
                }
            }
        }
        .resume()
    }


    func getGroupsOfNews(groupsIDs: String, completion: @escaping (VKResponseArray<VKGroup>?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getGroupsOfNews)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "group_ids", value: groupsIDs),
            URLQueryItem(name: "fields", value: "description"),
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.global().async {
                    let vkResponse = try? JSONDecoder().decode(VKResponseArray<VKGroup>.self, from: data)
                    DispatchQueue.main.async {
                         completion(vkResponse)
                    }
                }
            }
        }
        .resume()
    }
    
    func getUsersOfNews(usersIDs: String, completion: @escaping (VKResponseArray<VKUser>?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getUserOfNews)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "user_ids", value: usersIDs),
            URLQueryItem(name: "fields", value: "photo_200"),
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.global().async {
                    let vkResponse = try? JSONDecoder().decode(VKResponseArray<VKUser>.self, from: data)
                    DispatchQueue.main.async {
                         completion(vkResponse)
                    }
                }
            }
        }
        .resume()
    }
}
