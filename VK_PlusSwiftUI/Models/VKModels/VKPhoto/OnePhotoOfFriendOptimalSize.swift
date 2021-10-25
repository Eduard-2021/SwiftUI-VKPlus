//
//  OnePhotoOptimalSize.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

import SwiftUI

struct OnePhotoOfFriendOptimalSize: Identifiable {
    var idUser: Int = 0
    var serialNumberPhoto: Int = 0
    var idPhoto: Int = 0
    var imageURL: String = ""
    var numLikes: Int = 0
    var i_like: Bool = false
    var userPhoto: UIImage?
    var heightInGrid: Float = 0
    var id = UUID()
}

