//
//  VKGroup.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

import  SwiftUI

struct VKGroup: Identifiable {
    let idGroup : Int
    let nameGroup: String
    let imageGroupURL : String
    var groupAvatar: UIImage?
    var id = UUID()
}

extension VKGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case idGroup = "id"
        case nameGroup = "name"
        case imageGroupURL = "photo_200"
    }
}
