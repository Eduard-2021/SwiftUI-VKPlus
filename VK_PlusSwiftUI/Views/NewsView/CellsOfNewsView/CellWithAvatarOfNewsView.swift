//
//  CellWithAvatarOfNewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 10.10.2021.
//

import SwiftUI

struct CellWithAvatarOfNewsView: View {
    let sizeAvatar: CGFloat = 60
    @EnvironmentObject var loadNews: LoadNews
//    let oneNews: OneNews
    let index: Int
    
    var body: some View {
        HStack {
            ZStack {
                ViewBuilderForShadowAvatar(sizePhoto: sizeAvatar) {
                    Circle()
                }
                Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: sizeAvatar, height: sizeAvatar)
                if (loadNews.newsVK[index].sourceID > 0) && (loadNews.newsVK[index].newsUserVK.userAvatar != nil) {
                    Image(uiImage: loadNews.newsVK[index].newsUserVK.userAvatar!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .modifier(ModifierForAvatar(sizePhoto: sizeAvatar))
                }
                else if (loadNews.newsVK[index].sourceID < 0 ) && (loadNews.newsVK[index].newsGroupVK.groupAvatar != nil) {
                
                        Image(uiImage: loadNews.newsVK[index].newsGroupVK.groupAvatar!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .modifier(ModifierForAvatar(sizePhoto: sizeAvatar))
                } else {
                    EmptyView()
                }
            }
            Spacer().frame(width: 20)
            VStack(alignment: .leading, spacing: 3){
                Text("\(loadNews.newsVK[index].sourceID > 0 ? loadNews.newsVK[index].newsUserVK.fullName : loadNews.newsVK[index].newsGroupVK.nameGroup )")
                    .foregroundColor(Color.blue)
                Text("\(converDate(dateNoConvert: loadNews.newsVK[index].date))")
                    .font(.system(size: 13))
                    .foregroundColor(Color(#colorLiteral(red: 0.829913497, green: 0.829913497, blue: 0.829913497, alpha: 1)))
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    func converDate(dateNoConvert: Double) -> String {
        let date = NSDate(timeIntervalSince1970: dateNoConvert)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YYYY hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }
    
}

