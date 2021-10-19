//
//  VKNextGroupOfNews.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct VKNextGroupOfNews {
    let nextGroupFrom: String
}

extension VKNextGroupOfNews: Codable {
    enum CodingKeys: String, CodingKey {
        case nextGroupFrom = "next_from"
    }
}
