//
//  FriendsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

class staticProperies{
    static var fetchFriend: FriendEntity?
}

import SwiftUI
import CoreData

struct  FriendsView: View {
    var loadFriends = LoadFriends()
    let navigationController: UINavigationController
    let mainNavigationController: UINavigationController
    
    @State var searchText = ""
    @StateObject var friendsViewModel: FriendsViewModel
    @State var isPressedButtonSearch = false
    @State var indexOfSelectedRow = 0
    @State var isPressedButtonAddFriend = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: FriendEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FriendEntity.fullName, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var friends: FetchedResults<FriendEntity>
    
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.2119982541, green: 0.5794246793, blue: 0.9729811549, alpha: 1)))
                        .frame(width: UIScreen.main.bounds.width, height: 70 )
                    if !isPressedButtonSearch {StandartBarTitleForFriendAndGroups(isPressedButtonSearch: $isPressedButtonSearch, isPressedButtonAddItem:  $isPressedButtonAddFriend, titleText: "Друзья")}
                    else {SearchBarTitleForFriendAndGroups(isPressedButtonSearch: $isPressedButtonSearch, searchText: $searchText)}
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack {
                        ForEach(resultsSearch.indices, id: \.self) { index in
                            rowOfList(resultsSearch: resultsSearch, index: index)
                                .tag(index)
                                .onTapGesture {
                                    indexOfSelectedRow = Int(index)
                                    DispatchQueue.main.async {
                                        staticProperies.fetchFriend = resultsSearch[indexOfSelectedRow]
                                    }
                                    DispatchQueue.main.async {
                                        friendsViewModel.isPressedRow = !friendsViewModel.isPressedRow
                                    }
                                }
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.top, 10)
            }
            .navigationBarHidden(true)
        .onAppear() {
            loadFriends.load(managedObjectContext: managedObjectContext, fetchedFriends: friends)
            mainNavigationController.setNavigationBarHidden(true, animated: false)
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        
    }
    
    var resultsSearch: [FetchedResults<FriendEntity>.Element] {
        if searchText.isEmpty {
            return friends.map{$0}
        } else {
            return friends.filter{$0.fullName!.contains(searchText)}
        }
    }
}




