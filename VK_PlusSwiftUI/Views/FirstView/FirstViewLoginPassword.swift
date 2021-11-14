//
//  ContentView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 19.09.2021.
//

import SwiftUI
import Combine


struct FirstViewLoginPassword: View {
    
    let navigationController: UINavigationController
    @StateObject var firstViewLoginPasswordModel: FirstViewLoginPasswordModel
    
    

    var body: some View {
            VStack {
                LogPassSubView(isAuthorization: $firstViewLoginPasswordModel.isAuthorization)
            }
            .onAppear() {
                navigationController.setNavigationBarHidden(true, animated: false)
            }
    }
}

extension UIApplication {
   func endEditing() {
       sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}



