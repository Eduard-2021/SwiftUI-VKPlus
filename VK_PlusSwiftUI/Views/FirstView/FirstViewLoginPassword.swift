//
//  ContentView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 19.09.2021.
//

import SwiftUI
import Combine

struct FirstViewLoginPassword: View {
    
    @State private var isAuthorization = true
    

    var body: some View {
        NavigationView {
            VStack {
                LogPassSubView(isAuthorization: $isAuthorization)
                    .fullScreenCover(isPresented: $isAuthorization, content: {
                            WebLoad()
                    })
            }
        }
    }
}

extension UIApplication {
   func endEditing() {
       sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstViewLoginPassword()
//    }
//}


