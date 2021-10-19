//
//  VKNewsVideo.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct VKNewsVideo {
    var id: Int = 0
    var ownerID : Int = 0
    var title: String = ""
    var image = CoverPhoto()
}

extension VKNewsVideo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, image
        case ownerID = "owner_id"
    }
}

struct CoverPhoto: Decodable {
    var height: Int = 0
    var width: Int = 0
    var url: String = ""
}
