//
//  VKResponseDecodable.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 28.09.2021.
//

struct VKResponseDecodable<T:Decodable>: Decodable {
    let response: T
}
