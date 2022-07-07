//
//  GlobalProperties.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 06.10.2021.
//

import Foundation

class GlobalProperties {
    static let share = GlobalProperties()
    var useDataFromNet = true
    var context = CoreDataService(modelName: "MainContainer").context
    
    private init(){}
}
