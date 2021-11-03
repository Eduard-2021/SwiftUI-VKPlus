//
//  GroupsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI
import CoreData

var isReturnOnGroupsView = false

struct  GroupsView: View {
    @ObservedObject var loadGroups = LoadFromNetAllGroupsInCoreData()
    @State var isPressedButtonAddGroups = false
    @State var isPressedButtonSearch = false
    let sizeAvatar: CGFloat = 80
    let compression: CGFloat = 0.8
    @State var searchText = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: GroupEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GroupEntity.nameGroup, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var fetchedGroups: FetchedResults<GroupEntity>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: AllGroupView(), isActive: $isPressedButtonAddGroups, label: {EmptyView()})
                ZStack {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.2119982541, green: 0.5794246793, blue: 0.9729811549, alpha: 1)))
                        .frame(width: UIScreen.main.bounds.width, height: 70 )
                    if !isPressedButtonSearch {StandartBarTitleForFriendAndGroups(isPressedButtonSearch: $isPressedButtonSearch, isPressedButtonAddItem:  $isPressedButtonAddGroups, titleText: "Сообщества")}
                    else {SearchBarTitleForFriendAndGroups(isPressedButtonSearch: $isPressedButtonSearch, searchText: $searchText)}
                }
                
                Spacer().frame(height: 10)

                List() {
                    ForEach(resultsSearch) { groupVK in
                        HStack {
                            ViewAvatarWithAnimation(sizeAvatar: sizeAvatar, compression: compression, avatar: groupVK.groupAvatar)
                            Spacer().frame(width: 20)
                            Text("\(groupVK.nameGroup!)")
                            Spacer()
                            
                        }
                        .padding(.horizontal, 0)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
        .onAppear(){
            loadGroups.load(fetchedGroups: fetchedGroups, managedObjectContext: managedObjectContext)
        }
        .environmentObject(loadGroups)
    }
    
    func delete(at offsets: IndexSet) {
        SaveAndDeleteGroupInCoreData().delete(groupForDelete: fetchedGroups[offsets.first!], managedObjectContext: managedObjectContext)
    }
    
    var resultsSearch: [FetchedResults<GroupEntity>.Element] {
        if searchText.isEmpty {
            return fetchedGroups.map{$0}
        } else {
            return fetchedGroups.filter({$0.nameGroup!.contains(searchText)})
        }
    }
}



