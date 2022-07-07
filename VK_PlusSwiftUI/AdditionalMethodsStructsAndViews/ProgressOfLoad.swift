//
//  ProgressOfLoad.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 11.10.2021.
//

import SwiftUI

struct ProgressOfLoad: View {
    var heigth: CGFloat
    var color: Color
    var message: String
    
    var body: some View {
        VStack{
            Spacer()
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: color))
            Text("\(message)")
                .foregroundColor(.black)
                .font(.system(size: 12))
                .padding()
            Spacer()
        }
        .frame(height: heigth)
    }
}

