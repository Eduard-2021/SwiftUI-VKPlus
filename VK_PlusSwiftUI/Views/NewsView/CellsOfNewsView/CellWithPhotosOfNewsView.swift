//
//  CellPhotosOfNewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 09.10.2021.
//

import SwiftUI

struct CellWithPhotosOfNewsView: View {
    @EnvironmentObject var loadNews: LoadNews
    let indexOfOneNews: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: HorizontalAlignment.leading) {
                if (loadNews.newsVK[indexOfOneNews].numberPhotosInEachRow.count != 0) && (loadNews.newsVK[indexOfOneNews].arrayOfLargestPhotosOfNews.count == loadNews.newsVK[indexOfOneNews].numberPhotoInAttachement) {
                    ForEach(0...(loadNews.newsVK[indexOfOneNews].numberPhotosInEachRow.count-1), id: \.self) {index in
                        HStack {
                            ForEach(0...(loadNews.newsVK[indexOfOneNews].numberPhotosInEachRow[index]-1), id: \.self) {value in
                                if !loadNews.newsVK[indexOfOneNews].arrayOfLargestPhotosOfNews.isEmpty {
                                Image(uiImage: loadNews.newsVK[indexOfOneNews].arrayOfLargestPhotosOfNews[loadNews.newsVK[indexOfOneNews].numberPostedPhotoInPreviousRows[index]+value])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: loadNews.newsVK[indexOfOneNews].sizePhotosInRows[index])
                                }  else {
                                    EmptyView()
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: loadNews.heightCellWithPhotoOfNewsView)
    }
}
