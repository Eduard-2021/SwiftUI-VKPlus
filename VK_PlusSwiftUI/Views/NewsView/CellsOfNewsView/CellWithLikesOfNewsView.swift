//
//  CellWithLikesOfNewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 10.10.2021.
//

import SwiftUI

struct CellWithLikesOfNewsView: View {
    @EnvironmentObject var loadNews: LoadNews
    var index: Int
    let heightIcons: CGFloat = 20
    let basegrayColor = Color(#colorLiteral(red: 0.829913497, green: 0.829913497, blue: 0.829913497, alpha: 1))
    @State var isLikeNews = false
    @Binding var numberRow: Int
    
    var body: some View {
        HStack {
            Group{
                Image(systemName: isLikeNews ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(height: heightIcons)
                    .foregroundColor(isLikeNews ? Color.red : basegrayColor)
                    .onTapGesture {
                        if !isLikeNews {
                            loadNews.newsVK[index].likes.userLikes += 1
                            loadNews.newsVK[index].likes.count += 1
                        }
                        else {
                            loadNews.newsVK[index].likes.userLikes -= 1
                            loadNews.newsVK[index].likes.count -= 1
                        }
                        isLikeNews.toggle()
                    }
                Text("\(loadNews.newsVK[index].likes.count)")
                    .font(.system(size: 13))
                Spacer().frame(width: 30)
            }
            Group{
                Image(systemName: "bubble.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: heightIcons)
                        .foregroundColor(basegrayColor)
                Text("\(loadNews.newsVK[index].comments.count)")
                    .font(.system(size: 13))
                Spacer().frame(width: 10)
            }
            Group {
                Image(systemName: "arrowshape.turn.up.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(height: heightIcons)
                        .foregroundColor(basegrayColor)
                Text("\(loadNews.newsVK[index].reposts.count)")
                    .font(.system(size: 13))
                Spacer()
            }
            Group {
                Image(systemName: "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(height: heightIcons)
                        .foregroundColor(basegrayColor)
                Text("\(loadNews.newsVK[index].views.count)")
                    .font(.system(size: 13))
            }
        }
        .onAppear(){
            isLikeNews = (loadNews.newsVK[index].likes.userLikes > 0)
            numberRow = index
            if (loadNews.newsVK.count - index < 5) && !loadNews.nearLastElementInArrayOfNews {
                loadNews.load(isRefresh: false)
                loadNews.nearLastElementInArrayOfNews = true
            }
        }
    }
}

