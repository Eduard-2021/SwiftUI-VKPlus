//
//  LoadAllFoundGroups.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 25.10.2021.
//

import SwiftUI

class LoadAllFoundGroups: ObservableObject {
    @Published var groupsVK = [VKGroup]()
    let mainNetworkService = MainNetworkService()
    
    func load(searchText: String) {
        mainNetworkService.groupsSearch(textForSearch: searchText, numberGroups: 20) { (groups) in
            guard var groups = groups else {return}
            for (index, value) in groups.enumerated() {
                self.mainNetworkService.getPhotoFromNet(url: value.imageGroupURL) {(image) in
                    guard let image = image else {return}
                    groups[index].groupAvatar = image
                    if groups.last?.groupAvatar != nil {
                        self.groupsVK = groups
                    }
                }
            }
        }
    }
}
