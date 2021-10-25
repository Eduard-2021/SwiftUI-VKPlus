//
//  AllPhotosOfFriend.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 29.09.2021.
//

import SwiftUI
import CoreData


struct Constants {
    let spacingBetweenPhotos: CGFloat = 15
    let spacingOverLazyVGrid: CGFloat = 20
}

struct AllPhotosOfFriendView: View {
    var loadAllPhotosOfFriend = LoadFromNetAllPhotosInCoreData()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let constants = Constants()
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 25, alignment: .top), count: 2)

    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    @State var isPressedButtonLike = false
    @State var isPressedPhoto = false
    
    @State var rect = CGRect()
    
    @FetchRequest(
        entity: FriendPhotoOptimalSizeEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FriendPhotoOptimalSizeEntity.idPhoto, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var fetchedAllPhotosAllFriends: FetchedResults<FriendPhotoOptimalSizeEntity>
    
    var indicesFetchedAllPhotosFriend: [Int] {
        var fetch = [Int]()
        for index in fetchedAllPhotosAllFriends.indices {
            if fetchedAllPhotosAllFriends[index].friend == staticProperies.fetchFriend! {
                fetch.append(index)
            }
        }
        return fetch
    }
    
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                    if !indicesFetchedAllPhotosFriend.isEmpty {
                        ForEach(indicesFetchedAllPhotosFriend, id: \.self) {
                            index in
                                VStack {
                                    AllPhotosFriendView(fetchedPhotosFriend: fetchedAllPhotosAllFriends, index: index, indicesFetchedAllPhotosFriend: indicesFetchedAllPhotosFriend)
                                        .onTapGesture {
//                                            ClearContainerCoreData.deleteAll(managedObjectContext: managedObjectContext, fetchedEntity: fetchedAllPhotosAllFriends)
                                            isPressedPhoto = !isPressedPhoto
                                    }
                                    .fullScreenCover(isPresented: $isPressedPhoto, content: {BigPhotosOfFriedView(photosVK:fetchedAllPhotosAllFriends, indicesFetchedAllPhotosFriend: indicesFetchedAllPhotosFriend)})
                                    LikesView(fetchedPhotosFriend: fetchedAllPhotosAllFriends, index: index)
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
                loadAllPhotosOfFriend.load(fetchFriend: staticProperies.fetchFriend!, managedObjectContext: managedObjectContext)
        }
    }
}
    

struct AllPhotosFriendView: View {

    let fetchedPhotosFriend: FetchedResults<FriendPhotoOptimalSizeEntity>
    var index: Int
    
    var indicesFetchedAllPhotosFriend: [Int]
    
    var height : CGFloat { CGFloat(fetchedPhotosFriend[index].heightInGrid) }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(height: height)
            
            Image(uiImage: fetchedPhotosFriend[index].userPhoto ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(ShapeForGeometryGetter(fetchedPhotosFriend: fetchedPhotosFriend, index: index, indicesFetchedAllPhotosFriend: indicesFetchedAllPhotosFriend))
                .cornerRadius(10)
        }
    }
}


struct LikesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    let fetchedPhotosFriend: FetchedResults<FriendPhotoOptimalSizeEntity>
    var index: Int

    var body: some View {
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
                            if !fetchedPhotosFriend[index].i_like {
                                withAnimation {
                                    fetchedPhotosFriend[index].i_like = true
                                }
                                fetchedPhotosFriend[index].numLikes += 1
                            }
                            else {
                                withAnimation {
                                    fetchedPhotosFriend[index].i_like = false
                                }
                                fetchedPhotosFriend[index].numLikes -= 1
                            }
                            try! managedObjectContext.save()
                        }, label: {
                            Image(systemName: fetchedPhotosFriend[index].i_like  ?  "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(fetchedPhotosFriend[index].i_like ? Color.red : Color.blue)
                                .frame(width:20)
                                .rotation3DEffect(
                                    Angle(degrees: fetchedPhotosFriend[index].i_like ? 180 : 0),
                                    axis: (x: 0.0, y: 1.0, z: 0.0))
                                
                    })
                    }
                    Text("\(fetchedPhotosFriend[index].numLikes)")
                }
                Spacer().frame(width: 10)
            
        }
    }
}
