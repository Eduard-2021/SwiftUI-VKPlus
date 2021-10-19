//
//  VKGroupsOfNews.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct VKGroupsOfNews {
    let idGroup : Int
    let nameGroup: String
    let imageGroup : String
}

extension VKGroupsOfNews: Codable {
    enum CodingKeys: String, CodingKey {
        case idGroup = "id"
        case nameGroup = "name"
        case imageGroup = "photo_200"
    }
}
