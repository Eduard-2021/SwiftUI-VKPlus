//
//  MainCoordinator.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 09.11.2021.
//

import UIKit
import Combine
import SwiftUI

class MainCoordinator: CoordinatorProtocol {
    
    var coordinators: [CoordinatorProtocol]?
    
    private let firstViewLoginPasswordModel = FirstViewLoginPasswordModel()
    private let webLoadViewModel = WebLoadViewModel()
    
    private let coreDataService: CoreDataService = CoreDataService(modelName: "MainContainer")
    private var cancellables: Set<AnyCancellable> = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let firstViewLoginPasswordController = createAndLoadInNavigatioControllerFirstView()
        creatingObserverForFirstLoginView(firstViewLoginPasswordController: firstViewLoginPasswordController)
        creatingObserverForWebLoadView()
    }
    
    private func createAndLoadInNavigatioControllerFirstView() -> UIViewController {
        let firstViewLoginPassword = FirstViewLoginPassword(navigationController: navigationController, firstViewLoginPasswordModel: self.firstViewLoginPasswordModel)
        let firstViewLoginPasswordController = UIHostingController(rootView: firstViewLoginPassword)
        navigationController.pushViewController(firstViewLoginPasswordController, animated: false)
        return firstViewLoginPasswordController
    }
    
    private func creatingObserverForFirstLoginView(firstViewLoginPasswordController: UIViewController) {
        firstViewLoginPasswordModel
            .$isAuthorization
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isUserLoggedIn in
                guard let self = self else { return }
                if isUserLoggedIn {
                    let webLoadController = UIHostingController(rootView: WebLoadView(webLoadViewModel: self.webLoadViewModel).environment(\.managedObjectContext, GlobalProperties.share.context))
                    self.navigationController.pushViewController(webLoadController, animated: true)
                } else {
                    self.navigationController.popToViewController(firstViewLoginPasswordController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func creatingObserverForWebLoadView() {
        webLoadViewModel
            .$isAuthorizationVK
            .removeDuplicates()
            .subscribe(on: RunLoop.main)
            .sink {
                [weak self] isAuthorizationVK in
                if isAuthorizationVK {
                    guard let self = self else { return }
                    let tabBarVC = UITabBarController()
                    let friendsCoordinator = FriendsCoordinator(mainNavigationController: self.navigationController)
                    let groupsCoordinator = GroupsCoordinator()
                    let newsCoordinator = NewsCoordinator()
                    friendsCoordinator.start()
                    groupsCoordinator.start()
                    newsCoordinator.start()
                    self.coordinators = [friendsCoordinator, groupsCoordinator, newsCoordinator]
                    friendsCoordinator.navigationController.title = "Friends"
                    groupsCoordinator.navigationController.title = "Groups"
                    newsCoordinator.navigationController.title = "News"
                    tabBarVC.setViewControllers([friendsCoordinator.navigationController, groupsCoordinator.navigationController, newsCoordinator.navigationController], animated: false)
                    tabBarVC.tabBar.items?[0].image = UIImage(systemName: "person.fill")
                    tabBarVC.tabBar.items?[1].image = UIImage(systemName: "person.3.fill")
                    tabBarVC.tabBar.items?[2].image = UIImage(systemName: "newspaper.fill")
                    tabBarVC.modalPresentationStyle = .fullScreen
                    self.navigationController.pushViewController(tabBarVC , animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
