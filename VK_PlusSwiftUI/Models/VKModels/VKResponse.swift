//
//  VKResponse.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct VKResponse<T:Codable>: Codable {
    let response: T
}
