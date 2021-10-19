//
//  OnePhoto.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct OnePhoto {
    let idPhoto: Int
    let idUser: Int
    let differentSize: [Size]
    let allLikes : VKLikes
    let reposts : Reposts
}

struct Size: Codable {
    let height : Int
    let url : String
    let type : String
    let width : Int
}

struct VKLikes {
    let userLikes : Int
    let count : Int
}

struct Reposts: Codable  {
    let count : Int
}

extension OnePhoto: Codable {
    enum CodingKeys: String, CodingKey {
        case idPhoto = "id"
        case idUser = "owner_id"
        case differentSize = "sizes"
        case allLikes = "likes"
        case reposts = "reposts"
    }
}

extension VKLikes: Codable {
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}
