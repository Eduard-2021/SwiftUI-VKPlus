//
//  CallRefreshView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 11.10.2021.
//

import SwiftUI

struct CellRefreshView: View {
    @EnvironmentObject var loadNews: LoadNews
    @Binding var numberRow: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/8)
                .opacity(0.001)
                .gesture(DragGesture(minimumDistance: 10)
                            .onChanged {_ in
                                if numberRow <= 2 {
                                    loadNews.needDownloadLastNews = true
                                    loadNews.load(isRefresh: true)
                                }
                            })
            Spacer()
        }
    }
}


