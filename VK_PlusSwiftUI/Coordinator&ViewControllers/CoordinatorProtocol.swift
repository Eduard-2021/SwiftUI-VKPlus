//
//  Coordinator.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 09.11.2021.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    
    func start()
}
