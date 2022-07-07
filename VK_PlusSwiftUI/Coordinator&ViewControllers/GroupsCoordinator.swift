//
//  GroupsCoordinator.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 13.11.2021.
//

import UIKit
import Combine
import SwiftUI

class GroupsCoordinator: CoordinatorProtocol {
    
    var navigationController = UINavigationController()
    var groupsViewController: UIViewController!
    var groupsViewModel = GroupsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    func start() {
        createAndLoadInNavigatioControllerGroupsView()
        creatingObserverForGroupsView()
    }
    
    private func createAndLoadInNavigatioControllerGroupsView() {
        let groupsView = GroupsView(navigationController: navigationController, groupsViewModel: self.groupsViewModel).environment(\.managedObjectContext, GlobalProperties.share.context)
        groupsViewController = UIHostingController(rootView: groupsView)
        navigationController.pushViewController(groupsViewController, animated: false)
    }
    
    private func creatingObserverForGroupsView() {
        groupsViewModel
            .$isPressedButtonAddGroups
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isPressedButtonAddGroups in
                if isPressedButtonAddGroups {
                    guard let self = self else { return }
                        let allGroupViewController = UIHostingController(rootView: AllGroupsView().environment(\.managedObjectContext, GlobalProperties.share.context))
                        self.navigationController.pushViewController(allGroupViewController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
