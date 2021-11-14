//
//  AllGroupView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 04.10.2021.
//

import SwiftUI

struct  AllGroupsView: View {

    @ObservedObject var loadAllFoundGroups = LoadAllFoundGroups()
    @State var isPressButtonSearchGroups = false
    @State var searchText = "Music"
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    let sizeAvatar: CGFloat = 80
    let compression: CGFloat = 0.8

    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height:10)
                ZStack{
                    HStack{
                        Spacer().frame(width:23)
                        Image(systemName: "magnifyingglass")
                        Spacer()
                    }
                    TextField("Поиск группы", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(height: 35)
                        .padding(.leading,45)
                        .padding(.trailing,20)
                        .colorMultiply(Color(#colorLiteral(red: 0.9208785295, green: 0.9208785295, blue: 0.9208785295, alpha: 1)))
                }
                List() {
                    ForEach(resultsSearch) { groupVK in
                            HStack {
                                ViewAvatarWithAnimation(sizeAvatar: sizeAvatar, compression: compression, avatar: groupVK.groupAvatar)
                                Spacer().frame(width: 20)
                                Text("\(groupVK.nameGroup)")
                                Spacer()
                            }
                            .padding(.horizontal, 0)
                            .onTapGesture {
                                SaveAndDeleteGroupInCoreData().save(newGroup: groupVK, managedObjectContext: managedObjectContext)
                                self.presentation.wrappedValue.dismiss()
                            }
                    }
                }
            }
        .navigationBarTitle("", displayMode: .inline)
        }
        .onAppear(){
            loadAllFoundGroups.load(searchText: searchText.lowercased())
        }
    }
    
    
    var resultsSearch: [VKGroup] {
        if searchText.isEmpty {
            return []
        } else {
            loadAllFoundGroups.load(searchText: searchText.lowercased())
            return loadAllFoundGroups.groupsVK
        }
    } 
}



