//
//  ButtonBack.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 04.10.2021.
//

import SwiftUI

struct ButtonBack: View {
    let presentation: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            let constants = Constants()
            HStack(spacing: 0) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.blue)
                    .font(.system(size: constants.spacingOverLazyVGrid))
                
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text(" Back")
                        .foregroundColor(.blue)
                })
                Spacer()
            }
            .padding(.horizontal, 8)
            Spacer()
        }
    }
}
