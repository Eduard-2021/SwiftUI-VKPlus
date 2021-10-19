//
//  OneVKProfiles.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct OneVKProfiles {
    let firstName: String
    let id: Int
    let lastName: String
    let photoURL: String
}

extension OneVKProfiles: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photoURL = "photo_100"
    }
}
