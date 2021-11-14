//
//  VK_PlusSwiftUIApp.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 19.09.2021.
//

import SwiftUI

@main
//struct VK_PlusSwiftUIApp: App {
//
//    let coreDataService = CoreDataService(modelName: "MainContainer")
//
//    var body: some Scene {
//        WindowGroup {
//            FirstViewLoginPassword().environment(\.managedObjectContext, coreDataService.context)
//        }
//    }
//}

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.

        // Create the SwiftUI view that provides the window contents.
        mainCoordinator = MainCoordinator(navigationController: UINavigationController())

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = mainCoordinator?.navigationController
            self.window = window
            window.makeKeyAndVisible()
            
            mainCoordinator?.start()
        }
    }
}
