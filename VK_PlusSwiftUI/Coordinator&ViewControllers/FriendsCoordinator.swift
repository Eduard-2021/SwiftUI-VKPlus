//
//  FriendsCoordinator.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 13.11.2021.
//

import UIKit
import Combine
import SwiftUI

class FriendsCoordinator: CoordinatorProtocol {
    
    init(mainNavigationController: UINavigationController){
        self.mainNavigationController = mainNavigationController
    }

    let mainNavigationController: UINavigationController
    var navigationController = UINavigationController()
    var friendsViewController: UIViewController!
    let friendsViewModel = FriendsViewModel()
    private var cancellables: Set<AnyCancellable> = []
 
    func start() {
        createAndLoadInNavigatioControllerFriendsView()
        creatingObserverForFriendsView() 
    }
    
    private func createAndLoadInNavigatioControllerFriendsView() {
        let friendsView = FriendsView(navigationController: navigationController, mainNavigationController: mainNavigationController, friendsViewModel: self.friendsViewModel).environment(\.managedObjectContext, GlobalProperties.share.context)
        friendsViewController = UIHostingController(rootView: friendsView)
        navigationController.pushViewController(friendsViewController, animated: false)
    }
    
    private func creatingObserverForFriendsView() {
       friendsViewModel
            .$isPressedRow
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isPressedRow in
                if isPressedRow {
                    guard let self = self else { return }
                    var allPhotosOfFriendView = AllPhotosOfFriendView(navigationController: self.navigationController)
                    allPhotosOfFriendView.coordinator = self
                    let allPhotosOfFriendViewWithManagedObjectContext = allPhotosOfFriendView.environment(\.managedObjectContext, GlobalProperties.share.context)
                    let allPhotosOfFriendViewController = UIHostingController(rootView: allPhotosOfFriendViewWithManagedObjectContext)
                    self.navigationController.pushViewController(allPhotosOfFriendViewController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func showBigPhoto(photosVK: FetchedResults<FriendPhotoOptimalSizeEntity>, indicesFetchedAllPhotosFriend: [Int]) {
        let bigPhotoOfFriendView = BigPhotosOfFriedView(photosVK:photosVK, indicesFetchedAllPhotosFriend: indicesFetchedAllPhotosFriend, navigationController: navigationController).environment(\.managedObjectContext, GlobalProperties.share.context)
        let bigPhotoOfFriendViewController = UIHostingController(rootView: bigPhotoOfFriendView)
        self.navigationController.pushViewController(bigPhotoOfFriendViewController, animated: true)
    }
}
