//
//  SceneDelegate.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabbar()
        window?.makeKeyAndVisible()
    }
    
    func createMainNC() -> UINavigationController {
        let mainVC = MainVC()
        mainVC.title = "MyMoVieS"
        mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), tag: 0)
        
        return UINavigationController(rootViewController: mainVC)
    }
    
    func createMoviesNC() -> UINavigationController {
        let moviesVC = MoviesVC()
        moviesVC.title = "Movies"
        moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "movieclapper.fill"), tag: 1)
        
        return UINavigationController(rootViewController: moviesVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 2)
        
        return UINavigationController(rootViewController: favoritesVC )
    }

//    func createTabbar() -> UITabBarController {
//        let tabbar = UITabBarController()
//        UITabBar.appearance().tintColor = .systemRed
//        UITabBar.appearance().backgroundColor = .secondarySystemBackground
//        tabbar.viewControllers = [createMainNC(), createMoviesNC(), createFavoritesNC()]
//
//        return tabbar
//    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        
        // Customize the appearance of the tab bar
        UITabBar.appearance().tintColor = .systemRed
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
        
        // Customize the navigation bar title text attributes
        let titleFont = UIFont.boldSystemFont(ofSize: 20) // Set your desired font size here
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.systemRed // Optional: Set title color
        ]
        
        // Customize the tab bar item text attributes
        let font = UIFont.boldSystemFont(ofSize: 13) // Set your desired font size here
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        
        tabbar.viewControllers = [createMainNC(), createMoviesNC(), createFavoritesNC()]
        
        return tabbar
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

