//
//  AllPhotosOfFriend.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 29.09.2021.
//

import SwiftUI
import UIKit

var isReturnOnAllPhotosOfFriendView = false

struct Constants {
    let spacingBetweenPhotos: CGFloat = 15
    let spacingOverLazyVGrid: CGFloat = 20
}

struct AllPhotosOfFriend: View {
    @StateObject var loadAllPhotosOfFriend = LoadAllPhotosOfFriend()
    var usersVK: [VKUser]
    @Binding var index: Int
    
    let constants = Constants()
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 25, alignment: .top), count: 2)

    
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    @State var isPressedButtonLike = false
    @State var isPressedPhoto = false
    
    @State var rect = CGRect()

    var body: some View {
        ZStack {
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                            ForEach(loadAllPhotosOfFriend.photosVK.indices, id: \.self) {
                                index in
                                VStack {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(height: loadAllPhotosOfFriend.photosVK[index].sizeInGrid.height)
                                            
                                            Image(uiImage: loadAllPhotosOfFriend.photosVK[index].userPhoto ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .padding()
                                                .background(ShapeForGeometryGetter(loadAllPhotosOfFriend: loadAllPhotosOfFriend, index: index))
                                                .cornerRadius(10)
                                            }
                                    .onTapGesture {
                                        isPressedPhoto = !isPressedPhoto
                                    }
                                    .fullScreenCover(isPresented: $isPressedPhoto, content: {BigPhoto(photosVK:loadAllPhotosOfFriend.photosVK)})
                                
                                    HStack {
                                        Spacer()
                                        HStack(spacing: 0) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white.opacity(0.001))
                                                    .frame(width: 40, height: 40)
                                                    .onTapGesture {
                                                        
                                                    }
                                                Button(action: {
                                                    if !loadAllPhotosOfFriend.photosVK[index].i_like {
                                                        withAnimation {
                                                            loadAllPhotosOfFriend.photosVK[index].i_like = true
                                                        }
                                                        loadAllPhotosOfFriend.photosVK[index].numLikes += 1
                                                    }
                                                    else {
                                                        withAnimation {
                                                            loadAllPhotosOfFriend.photosVK[index].i_like = false
                                                        }
                                                        loadAllPhotosOfFriend.photosVK[index].numLikes -= 1
                                                    }
                                                }, label: {
                                                    Image(systemName: loadAllPhotosOfFriend.photosVK[index].i_like  ?  "heart.fill" : "heart")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundColor(loadAllPhotosOfFriend.photosVK[index].i_like ? Color.red : Color.blue)
                                                        .frame(width:20)
                                                        .rotation3DEffect(
                                                            Angle(degrees: loadAllPhotosOfFriend.photosVK[index].i_like ? 180 : 0),
                                                            axis: (x: 0.0, y: 1.0, z: 0.0))
                                                        
                                            })
                                            }
                                            Text("\(loadAllPhotosOfFriend.photosVK[index].numLikes)")
                                        }
                                        Spacer().frame(width: 10)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                        .navigationBarHidden(true)
                    }
                    .padding(.top,50)
            ButtonBack(presentation: presentation)
        }
       .padding(.top,25)
       .onAppear() {
            if !isReturnOnAllPhotosOfFriendView {
                loadAllPhotosOfFriend.load(userVK: usersVK[index])
            }
        }
    }
}
    
    
struct ShapeForGeometryGetter: View {
    @ObservedObject var loadAllPhotosOfFriend: LoadAllPhotosOfFriend
    let index: Int
    
    var body: some View {
        return GeometryGetter(){(rect) in
            if loadAllPhotosOfFriend.photosVK.first(where: {$0.sizeInGrid.height == 0}) != nil {
                loadAllPhotosOfFriend.photosVK[index].sizeInGrid = rect
                }
                else {
                    for i in 0...index {
                        calculatingSizePadding(index: i)
                }
            }
        }
    }
    
    private func calculatingSizePadding(index: Int) {
        if index % 2 != 0 {
            let odds = loadAllPhotosOfFriend.photosVK[index].sizeInGrid.height - loadAllPhotosOfFriend.photosVK[index-1].sizeInGrid.height
            
            if odds > 0 {
                loadAllPhotosOfFriend.photosVK[index-1].sizeInGrid = loadAllPhotosOfFriend.photosVK[index].sizeInGrid
            }
            else {
                loadAllPhotosOfFriend.photosVK[index].sizeInGrid = loadAllPhotosOfFriend.photosVK[index-1].sizeInGrid
            }
        }
     }
}


class LoadAllPhotosOfFriend: ObservableObject {
    @Published var photosVK = [OnePhotoOfFriendOptimalSize]()
    let mainNetworkService = MainNetworkService()
    
    func load(userVK: VKUser) {
        //Блок для отладки без доступа к сети
        if !GlobalProperties.share.useDataFromNet {
            var photos = [OnePhotoOfFriendOptimalSize]()

            photos.append(OnePhotoOfFriendOptimalSize(
                            idUser: userVK.idUser,
                            serialNumberPhoto: 0,
                            idPhoto: 0,
                            URLimage: "",
                            numLikes: 5,
                            i_like: true,
                            userPhoto:UIImage(named: "сливки")
                          ))

            photos.append(OnePhotoOfFriendOptimalSize(
                            idUser: userVK.idUser,
                            serialNumberPhoto: 0,
                            idPhoto: 0,
                            URLimage: "",
                            numLikes: 8,
                            i_like: false,
                            userPhoto:UIImage(named: "milk3")
                          ))

            photos.append(OnePhotoOfFriendOptimalSize(
                            idUser: userVK.idUser,
                            serialNumberPhoto: 0,
                            idPhoto: 0,
                            URLimage: "",
                            numLikes: 3,
                            i_like: false,
                            userPhoto:UIImage(named: "milk3")
                          ))
            photosVK = photos
        }
        else {
            mainNetworkService.getAllPhotos(userId: String((userVK.idUser))) { (photos) in
                guard var photos = photos else {return}
                for (index, value) in photos.enumerated() {
                    self.mainNetworkService.getPhotoFromNet(url: value.URLimage) {(image) in
                        guard let image = image else {return}
                        photos[index].userPhoto = image
                        if photos.last?.userPhoto != nil {
                            self.photosVK = photos
                        }
                    }
                }
            }
        }
    }
}


