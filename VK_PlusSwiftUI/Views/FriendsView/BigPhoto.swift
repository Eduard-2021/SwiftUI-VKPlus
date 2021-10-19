//
//  BigPhoto.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 01.10.2021.
//

import SwiftUI

struct BigPhoto: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    var gridItemLayout = [GridItem(.flexible())]
    
    var photosVK: [OnePhotoOfFriendOptimalSize]
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout , alignment: .center) {
                    ForEach(photosVK.indices, id: \.self ) { index in
                        Image(uiImage: photosVK[index].userPhoto ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width-20)
                            .padding()
                            .cornerRadius(10)
                    }
                }
            }
            ButtonBack(presentation: presentation)
                .padding(.top,25)
        }
    }
}

