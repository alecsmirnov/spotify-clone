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
    
    private var dependencyContainer: DependencyContainer?
    private var coordinator: Coordinator?
    
    // MARK: Lifecycle
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupWindow(windowScene: windowScene)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        dependencyContainer?.spotifyAuthService.fetchAccessToken(from: url)
    }
}

// MARK: - Window Methods

private extension SceneDelegate {
    func setupWindow(windowScene: UIWindowScene) {
        setupDependencyContainer()
        
        let navigationController = UINavigationController()
        let router = Router(rootController: navigationController)
        
        coordinator = dependencyContainer?.makeAppCoordinator(router: router)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator?.start()
    }
    
    func setupDependencyContainer() {
        dependencyContainer = DependencyContainer()
        
        dependencyContainer?.spotifyAuthService.openAuthorizeURLCompletion = { url in
            UIApplication.shared.open(url)
        }
    }
}
