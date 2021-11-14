//
//  BigPhoto.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 01.10.2021.
//

import SwiftUI

struct BigPhotosOfFriedView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    var gridItemLayout = [GridItem(.flexible())]
    
    var photosVK: FetchedResults<FriendPhotoOptimalSizeEntity>
    var indicesFetchedAllPhotosFriend: [Int]
    
    let navigationController: UINavigationController
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout , alignment: .center) {
                    ForEach(indicesFetchedAllPhotosFriend, id: \.self ) { index in
                        Image(uiImage: photosVK[index].userPhoto ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width-20)
                            .padding()
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.bottom, 80)
            .padding(.top,25)
        }
        .onAppear(){
            navigationController.setNavigationBarHidden(false, animated: false)
        }
    }
}

