//
//  FriendsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI

struct  FriendsView: View {
    @StateObject var loadFriends = LoadFriends()
    @Binding var isRowSelected: Bool
    @State var searchText = ""
    @State var isPressedRow = false
    @State var indexOfSelectedRow = 0
    
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer().frame(height:10)
            ZStack{
                HStack{
                    Spacer().frame(width:23)
                    Image(systemName: "magnifyingglass")
                    Spacer()
                }
                TextField("Поиск друга", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(height: 35)
                    .padding(.leading,45)
                    .padding(.trailing,20)
                    .colorMultiply(Color(#colorLiteral(red: 0.9208785295, green: 0.9208785295, blue: 0.9208785295, alpha: 1)))
            }
            List {
                ForEach(resultsSearch.indices, id: \.self) { index in
                    rowOfList(resultsSearch: resultsSearch, index: index)
                        .tag(index)
                        .onTapGesture {
                            isPressedRow = !isPressedRow
                            indexOfSelectedRow = Int(index)
                        }
                        .fullScreenCover(isPresented: $isPressedRow, content: {
                            AllPhotosOfFriend(usersVK: resultsSearch, index: $indexOfSelectedRow)
                        })
                }
            }
        }
        .onAppear() {
                loadFriends.load()
        }
    }
    
    var resultsSearch: [VKUser] {
        if searchText.isEmpty {
            return loadFriends.usersVK
        } else {
            return loadFriends.usersVK.filter{$0.fullName.contains(searchText)}
        }
    }
}


class LoadFriends: ObservableObject {
    @Published var usersVK = [VKUser]()
    let mainNetworkService = MainNetworkService()
    
    func load() {
        if !GlobalProperties.share.useDataFromNet {
            //Блок для отладки без доступа к сети
            var users = [VKUser]()
            users.append(VKUser(idUser: 136356171, firstName: "Татьяна", lastName: "Фёдорова", userAvatarURL: "https://sun6-21.userapi.com/s/v1/ig2/ycAQmihyisevGtdBi5FYfoYySVH1YZi8jNyjO9fb4rfoU03NwaclUgqOejoNbUo6zekp3umboGX9rxdrKh8261T1.jpg?size=200x200&quality=95&crop=319,98,1115,1115&ava=1", userAvatar: UIImage(named: "сливки")))
            users.append(VKUser(idUser: 604130258, firstName: "Дарья", lastName: "Иванова", userAvatarURL: "https://sun6-22.userapi.com/s/v1/if1/gc2eCTVZEbAGvUEeDR-omUQWSxMTs3KD7X9M2DMjdtoGirZ76d2G1FCxRcbWnSzEB0e4QnVo.jpg?size=200x200&quality=96&crop=815,114,957,957&ava=1", userAvatar: UIImage(named: "сливки")))
            users.append(VKUser(idUser: 604131258, firstName: "Екатерина", lastName: "Вехрова", userAvatarURL: "https://sun6-22.userapi.com/s/v1/if1/gc2eCTVZEbAGvUEeDR-omUQWSxMTs3KD7X9M2DMjdtoGirZ76d2G1FCxRcbWnSzEB0e4QnVo.jpg?size=200x200&quality=96&crop=815,114,957,957&ava=1", userAvatar: UIImage(named: "milk3")))
            users.append(VKUser(idUser: 604131258, firstName: "Валентина", lastName: "Ветрова", userAvatarURL: "https://sun6-22.userapi.com/s/v1/if1/gc2eCTVZEbAGvUEeDR-omUQWSxMTs3KD7X9M2DMjdtoGirZ76d2G1FCxRcbWnSzEB0e4QnVo.jpg?size=200x200&quality=96&crop=815,114,957,957&ava=1", userAvatar: UIImage(named: "Фон")))

            users = users.sorted(by: {$0.fullName < $1.fullName})
            usersVK = users
        }
        else {
            mainNetworkService.getUserFriends() { (users) in
                guard var users = users else {return}
                for (index, value) in users.enumerated() {
                    self.mainNetworkService.getPhotoFromNet(url: value.userAvatarURL) {(image) in
                        guard let image = image else {return}
                        users[index].userAvatar = image
                        if !users.contains(where: {$0.userAvatar == nil}) {
                            users = users.sorted(by: {$0.fullName < $1.fullName})
                            self.usersVK = users
                        }
                    }
                }
            }
        }
    }
}


struct rowOfList: View {
    var resultsSearch: [VKUser]
    let index: Int
    let sizeAvatar: CGFloat = 80
    
    var body: some View {
        VStack {
            if index != 0 {
                if resultsSearch[index].lastName.first != resultsSearch[index-1].lastName.first {
                Text("\(String(resultsSearch[index].lastName.first ?? " "))")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
                    .background(Color.blue)
                }
            } else {
                Text("\(String(resultsSearch[index].lastName.first ?? " "))")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
                    .background(Color.blue)
            }
            
            HStack {
                ZStack {
                    ViewBuilderForShadowAvatar(sizePhoto: sizeAvatar) {
                        Circle()
                    }
                    Circle()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: sizeAvatar, height: sizeAvatar)
                    Image(uiImage: resultsSearch[index].userAvatar ?? UIImage(systemName: "hourglass.tophalf.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .modifier(ModifierForAvatar(sizePhoto: sizeAvatar))
                }
                Spacer().frame(width: 20)
                Text("\(resultsSearch[index].fullName)")
                Spacer()
            }
            .padding(.horizontal, 10)
        }
    }
}
