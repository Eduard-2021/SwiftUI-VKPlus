//
//  ViewBuilderForShedowAvatar.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 29.09.2021.
//

import SwiftUI

struct ViewBuilderForShadowAvatar: View {
    var content: Circle
    let sizePhoto: CGFloat
 
    init(sizePhoto: CGFloat,  @ViewBuilder content: () -> Circle) {
        self.sizePhoto = sizePhoto
        self.content = content()
    }
 
    var body: some View {
        content
            .fill(Color.white)
            .frame(width: sizePhoto, height: sizePhoto)
            .shadow(color: .black, radius: 7, x: 1, y: 2)
    }
}

