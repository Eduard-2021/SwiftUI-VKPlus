//
//  AllGroupView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 04.10.2021.
//

import SwiftUI

struct  AllGroupView: View {

    @ObservedObject var loadAllFoundGroups = LoadAllFoundGroups()
    @State var isPressButtonSearchGroups = false
    let sizePhoto: CGFloat = 80
    @State var searchText = "Music"
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
//    @EnvironmentObject var loadGroups: LoadGroups
    
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
                                ZStack {
                                    ViewBuilderForShadowAvatar(sizePhoto: sizePhoto) {
                                        Circle()
                                    }
                                    Circle()
                                        .stroke(Color.black, lineWidth: 1)
                                        .frame(width: sizePhoto, height: sizePhoto)
                                    Image(uiImage: groupVK.groupAvatar ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .modifier(ModifierForAvatar(sizePhoto: sizePhoto))

                                }
                                Spacer().frame(width: 20)
                                Text("\(groupVK.nameGroup)")
                                Spacer()
                            }
                            .padding(.horizontal, 0)
                            .onTapGesture {
                                SaveAndDeleteGroupInCoreData().save(newGroup: groupVK, managedObjectContext: managedObjectContext)
//                                loadGroups.groupsVK.append(groupVK)
                                self.presentation.wrappedValue.dismiss()
                            }
                    }
                }
            }
            
//            ButtonBack(presentation: presentation).padding(.top,15)
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



