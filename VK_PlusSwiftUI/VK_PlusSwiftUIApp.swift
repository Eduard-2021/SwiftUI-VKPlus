//
//  VK_PlusSwiftUIApp.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 19.09.2021.
//

import SwiftUI

@main
struct VK_PlusSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            if GlobalProperties.share.useDataFromNet {
                FirstViewLoginPassword()
            }
            else {
                //Отладка без запроса логина и пароля, а также без доступа к сети
                SecondViewWithTab()
            }
        }
    }
}
