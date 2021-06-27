//
//  SceneDelegate.swift
//  SpotifyClone
//
//  Created by Admin on 21.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Properties
    
    var window: UIWindow?
    
    private var coordinator: Coordinator?
    
    private lazy var appFactory: AppFactory = {
        let dependencyContainer = DependencyContainer()
        
        dependencyContainer.spotifyAPI.delegate = self
        
        return dependencyContainer
    }()
    
    // MARK: Lifecycle
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let router = Router(rootController: navigationController)
        
        coordinator = appFactory.makeAppCoordinator(router: router)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator?.start()
    }
}

// MARK: - SpotifyAPIDelegate

extension SceneDelegate: SpotifyAPIDelegate {
    func spotifyAPIOpenURL(_ sporifyAPI: SpotifyAPIProtocol, _ url: URL) {
        UIApplication.shared.open(url)
    }
}
