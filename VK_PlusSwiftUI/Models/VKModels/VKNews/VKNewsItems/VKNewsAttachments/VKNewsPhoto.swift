//
//  VKNewsPhoto.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

import SwiftUI

struct VKNewsPhoto  {
    var id: Int = 0
    var ownerID: Int = 0
    var userID: Int = 0
    var text: String = ""
    var date: Double = 0
    var sizes = [SizeVKNewsPhoto]()
    var aspectRatio: Double = 1
}
