//
//  NewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI

struct  NewsView: View {

    @StateObject var loadNews = LoadNews()
    @State var numberRow = 0
    
    private let currentTime = Date().timeIntervalSince1970
    private let durationOneDay : Double = 60*60*24
    
    var body: some View {
        ZStack {
            VStack {
                if loadNews.needDownloadLastNews {
                    ProgressOfLoad(heigth: UIScreen.main.bounds.height/8, color: .red, message: "Refreshing ...")
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .center, spacing: 10) {
                        if loadNews.newsVK.count == 0 {
//                            ProgressOfLoad(heigth: UIScreen.main.bounds.height, color: .gray, message: "")
                            ViewLoadingWith3AnimatedDots(heigth: UIScreen.main.bounds.height)
                        }
                        else {
                            ForEach(0...loadNews.newsVK.count-1, id: \.self) {indexOfNews in
                                    ForEach(0...4, id: \.self) { index in
                                        switch index {
                                        case 0 :
                                            CellWithGrayLineOfNewsView()
                                        case 1 :
                                            CellWithAvatarOfNewsView(index: indexOfNews)
                                        case 2 :
                                            CellWithPhotosOfNewsView(indexOfOneNews: indexOfNews)
                                        case 3 :
                                            CellWithCommentTextOfNewsView(index: indexOfNews)
                                        case 4 :
                                            CellWithLikesOfNewsView(index: indexOfNews, numberRow: $numberRow)
                                        default:
                                            EmptyView()
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .onAppear(){
                    loadNews.load(isRefresh: false)
                }
            }
            CellRefreshView(numberRow: $numberRow)
        }
        .environmentObject(loadNews)
    }
}



