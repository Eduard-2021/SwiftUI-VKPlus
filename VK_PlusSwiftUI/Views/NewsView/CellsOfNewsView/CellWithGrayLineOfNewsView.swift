//
//  CellWithGrayLineOfNewsView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 10.10.2021.
//

import SwiftUI

struct CellWithGrayLineOfNewsView: View {
    var body: some View {
        Rectangle()
            .fill(Color(#colorLiteral(red: 0.9412671328, green: 0.9412671328, blue: 0.9412671328, alpha: 1)))
            .frame(width: UIScreen.main.bounds.width, height: 1)
            .padding(.vertical,4)
    }
}

