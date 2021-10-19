//
//  GroupsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI

var isReturnOnGroupsView = false

struct  GroupsView: View {
    @ObservedObject var loadGroups = LoadGroups()
    @State var isPressButtonSearchGroups = false
    let sizePhoto: CGFloat = 80
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
                List() {
                    Group {
                        VStack {
                            ZStack{
                                NavigationLink(destination: AllGroupView(), isActive: $isPressButtonSearchGroups, label: {EmptyView()})
                                HStack {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                        
                                }
                                HStack {
                                    Spacer()
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(Color.blue)
                                        .background(Color.white)
//                                        .padding()
                                }
                            }
                            ZStack{
                                HStack{
//                                    Spacer().frame(width:23)
                                    Image(systemName: "magnifyingglass")
                                    Spacer()
                                }
                                TextField("Поиск группы", text: $searchText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                                    .frame(height: 35)
                                    .padding(.leading,25)
//                                    .padding(.trailing,20)
                                    .colorMultiply(Color(#colorLiteral(red: 0.9208785295, green: 0.9208785295, blue: 0.9208785295, alpha: 1)))
                            }
                        }
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
                        }
                        .onDelete(perform: delete)
                    }
                }
                .navigationBarHidden(true)
        }
        .onAppear(){
            if !isReturnOnGroupsView {loadGroups.load()}
            isReturnOnGroupsView = true
        }
        .environmentObject(loadGroups)
    }
    
    func delete(at offsets: IndexSet) {
        loadGroups.groupsVK.remove(atOffsets: offsets)
    }
    
    var resultsSearch: [VKGroup] {
        if searchText.isEmpty {
            return loadGroups.groupsVK
        } else {
            return loadGroups.groupsVK.filter({$0.nameGroup.contains(searchText)})
        }
    }
}

class LoadGroups: ObservableObject {
    @Published var groupsVK = [VKGroup]()
    let mainNetworkService = MainNetworkService()
    
    func load() {
        
        if !GlobalProperties.share.useDataFromNet {
            //Блок для отладки без доступа к сети
            var groups = [VKGroup]()
            groups.append(VKGroup(idGroup: 1, nameGroup: "First", imageGroupURL: "", groupAvatar: UIImage(named: "milk3")))
            groups.append(VKGroup(idGroup: 1, nameGroup: "Second", imageGroupURL: "", groupAvatar: UIImage(named: "Фон")))
            groups.append(VKGroup(idGroup: 1, nameGroup: "Thrid", imageGroupURL: "", groupAvatar: UIImage(named: "сливки")))
            groups.append(VKGroup(idGroup: 1, nameGroup: "Fourth", imageGroupURL: "", groupAvatar: UIImage(named: "milk3")))
            groupsVK = groups
        }
        else {
            mainNetworkService.getGroupsOfUser(userId: DataAboutSession.data.userID) { (groups) in
                guard var groups = groups else {return}
                for (index, value) in groups.enumerated() {
                    self.mainNetworkService.getPhotoFromNet(url: value.imageGroupURL) {(image) in
                        guard let image = image else {return}
                        groups[index].groupAvatar = image
                        if groups.last?.groupAvatar != nil {
                            self.groupsVK = groups
                        }
                    }
                }
            }
        }
    }
}

