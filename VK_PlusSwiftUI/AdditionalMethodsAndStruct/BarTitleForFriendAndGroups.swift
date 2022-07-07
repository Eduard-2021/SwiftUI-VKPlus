//
//  BarTitleForFriendAndGroups.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 20.10.2021.
//

import SwiftUI

struct StandartBarTitleForFriendAndGroups: View {
    @Binding var isPressedButtonSearch: Bool
    @Binding var isPressedButtonAddItem: Bool
    var titleText: String
    
    var body: some View {
        HStack{
            Button(action: {isPressedButtonSearch = false}, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20)
            })
            .padding(.leading,20)
            Text(titleText)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.system(size: 22))
                .padding(.leading,40)
            Spacer()
            Button(action: {isPressedButtonAddItem = true}, label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20)
            })
            .padding(.trailing,20)
            Button(action: {isPressedButtonSearch = true}, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20)
            })
            .padding(.trailing,20)
        }
    }
}

struct SearchBarTitleForFriendAndGroups: View {
    @Binding var isPressedButtonSearch: Bool
    @Binding var searchText: String
    var body: some View {
        HStack{
            Button(action: {isPressedButtonSearch = false}, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20)
            })
            .padding(.leading,20)
            TextField("Поиск", text: $searchText)
                .autocapitalization(.none)
                .frame(height: 35)
                .colorMultiply(Color(#colorLiteral(red: 0.2119982541, green: 0.5794246793, blue: 0.9729811549, alpha: 1)))
                .padding(.leading,30)
                
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 15)
            })
            .padding(.trailing,20)
        }
    }
}
