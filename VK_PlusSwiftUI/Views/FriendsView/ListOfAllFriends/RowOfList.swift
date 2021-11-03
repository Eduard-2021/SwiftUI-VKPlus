//
//  RowOfList.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//

import SwiftUI
import CoreData

struct rowOfList: View {
    var resultsSearch: [FetchedResults<FriendEntity>.Element]
    let index: Int
    let compression: CGFloat = 0.8
    let sizeAvatar: CGFloat = 70
    @State var isPressedPhoto = false
    
    var body: some View {
        VStack {
            if index != 0 {
                if resultsSearch[index].lastName!.first != resultsSearch[index-1].lastName!.first {
                Text("\(String(resultsSearch[index].lastName!.first ?? " "))")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
                }
            } else {
                Text("\(String(resultsSearch[index].lastName!.first ?? " "))")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
            }
            
            HStack {
                ViewAvatarWithAnimation(sizeAvatar: sizeAvatar, compression: compression, avatar: resultsSearch[index].userAvatar)
                
                Spacer().frame(width: 20)
                Text("\(resultsSearch[index].fullName!)")
                    .font(.system(size: 18))
                Spacer()
            }
            .padding(.horizontal, 10)
        }
    }
}
