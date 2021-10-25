//
//  VK_PlusSwiftUIApp.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 19.09.2021.
//

import SwiftUI

@main
struct VK_PlusSwiftUIApp: App {
    
    let coreDataService = CoreDataService(modelName: "MainContainer")
    
    var body: some Scene {
        WindowGroup {
            FirstViewLoginPassword().environment(\.managedObjectContext, coreDataService.context)
        }
    }
}

