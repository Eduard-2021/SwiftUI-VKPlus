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
    var URLimage: String = ""
    var numLikes: Int = 0
    var i_like: Bool = false
    var userPhoto: UIImage?
    var sizeInGrid = CGRect()
    var id = UUID()
}

//extension RealmUserPhoto {
//    convenience init(_ idUser: Int, _ onePhoto: OnePhoto, _ URLimage: String, _ likesVK: LikesVK) {
//        self.init()
//        self.idUser = idUser
//        self.serialNumberPhoto = 0
//        self.idPhoto = onePhoto.idPhoto
//        self.URLimage = URLimage
//        self.numLikes = likesVK.count
//        self.i_like = likesVK.userLikes == 1
//    }
//}
//
//class LikesVK: Object {
//    @objc dynamic var userLikes : Int = 0
//    @objc dynamic var count : Int = 0
//}
//
//extension LikesVK {
//    convenience init(_ likesVK: VKLikes) {
//        self.init()
//        self.userLikes = likesVK.userLikes
//        self.count = likesVK.count
//    }
//}
