//
//  SecondViewWithTab.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI

struct  SecondViewWithTab: View {
    @State var isRowSelected = false
    
    var body: some View {
        VStack {
            TabView {
                FriendsView(isRowSelected: $isRowSelected).tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
                }
                GroupsView().tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Groups")
                }
                NewsView().tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }
            }
        }
    }
}


