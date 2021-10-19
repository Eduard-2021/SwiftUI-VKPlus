//
//  CellWithCommentTextOfNewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 10.10.2021.
//

import SwiftUI

struct CellWithCommentTextOfNewsView: View {
    @EnvironmentObject var loadNews: LoadNews
    let index: Int
    
    var body: some View {
        if loadNews.newsVK[index].text != "" {
            Text("\(loadNews.newsVK[index].text)")
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
        }
        else {
            EmptyView()
        }
    }
}

