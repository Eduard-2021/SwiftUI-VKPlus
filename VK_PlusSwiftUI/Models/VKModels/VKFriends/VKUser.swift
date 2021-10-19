//
//  VKUser.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

import  SwiftUI

struct VKUser: Identifiable {
    let idUser: Int
    let firstName: String
    let lastName: String
    var fullName: String {
        return self.lastName + " " + self.firstName
    }
    let userAvatarURL: String
    var userAvatar: UIImage?
    var id = UUID()
}

extension VKUser: Codable {
    enum CodingKeys: String, CodingKey {
        case idUser = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case userAvatarURL = "photo_200"
    }
}

