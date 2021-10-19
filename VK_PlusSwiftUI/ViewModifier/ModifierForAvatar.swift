//
//  ModifierForAvatar.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 29.09.2021.
//

import SwiftUI

struct ModifierForAvatar: ViewModifier {
    let sizePhoto: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: sizePhoto, height: sizePhoto)
            .clipShape(Circle())
    }
}
