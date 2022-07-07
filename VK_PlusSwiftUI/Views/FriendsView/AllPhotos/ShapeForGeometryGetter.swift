//
//  ShapeForGeometryGetter.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 21.10.2021.
//

import SwiftUI

struct ShapeForGeometryGetter: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let fetchedPhotosFriend: FetchedResults<FriendPhotoOptimalSizeEntity>
    let index: Int
    var indicesFetchedAllPhotosFriend: [Int]
    
    var body: some View {
        return GeometryGetter(){(rect) in
            if fetchedPhotosFriend.first(where: {($0.heightInGrid == 0) && ($0.friend == staticProperies.fetchFriend!)}) != nil {
                fetchedPhotosFriend[index].heightInGrid = Float(rect.height)
                if fetchedPhotosFriend.first(where: {($0.heightInGrid == 0) && ($0.friend == staticProperies.fetchFriend!)}) == nil {
                    for i in 0...indicesFetchedAllPhotosFriend.count-1 {
                        calculatingSizePadding(index: i)
                    }
                }
            }
            if managedObjectContext.hasChanges {
                try! managedObjectContext.save()
            }
        }
    }
    
    private func calculatingSizePadding(index: Int) {
        if index % 2 != 0 {
            let odds = fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index]].heightInGrid - fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index-1]].heightInGrid
            
            if odds > 0 {
                fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index-1]].heightInGrid = fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index]].heightInGrid
            }
            else {
                fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index]].heightInGrid = fetchedPhotosFriend[indicesFetchedAllPhotosFriend[index-1]].heightInGrid
            }
        }
     }
}
