//
//  ViewAvatarWithAnimation.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 31.10.2021.
//

import SwiftUI

struct ViewAvatarWithAnimation: View {
    let sizeAvatar: CGFloat
    let compression: CGFloat
    let avatar: UIImage?
    
    @State var isPressedPhoto = false
 
    init(sizeAvatar: CGFloat,  compression: CGFloat, avatar: UIImage?) {
        self.sizeAvatar = sizeAvatar
        self.compression = compression
        self.avatar = avatar
    }
 
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: sizeAvatar, height: sizeAvatar)
            ViewBuilderForShadowAvatar(sizePhoto: isPressedPhoto ? sizeAvatar*compression : sizeAvatar ) {
                Circle()
            }
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: isPressedPhoto ? sizeAvatar*compression : sizeAvatar, height: isPressedPhoto ? sizeAvatar*compression : sizeAvatar)
            Image(uiImage: avatar ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .modifier(ModifierForAvatar(sizePhoto: isPressedPhoto ? sizeAvatar*compression : sizeAvatar))
        }
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.3)) {isPressedPhoto = true }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                withAnimation(Animation.spring(response: 0.25, dampingFraction: 0.2, blendDuration: 0.5)) {isPressedPhoto = false }
            }
        }
    }
}
