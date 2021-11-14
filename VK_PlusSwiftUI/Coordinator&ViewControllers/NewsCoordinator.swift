//
//  NewsCoordinator.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 13.11.2021.
//

import UIKit
import Combine
import SwiftUI

class NewsCoordinator: CoordinatorProtocol {
    
    var navigationController = UINavigationController()
    
    func start() {
        navigationController.pushViewController(UIHostingController(rootView: NewsView(navigationController: navigationController).environment(\.managedObjectContext, GlobalProperties.share.context)), animated: false)
    }
}
