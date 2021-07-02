//
//  DependencyContainer.swift
//  SpotifyClone
//
//  Created by Admin on 24.06.2021.
//

import Foundation

// TODO: Remove
import UIKit

final class DependencyContainer {
    private enum Constants {
        static let clientId = "f8b0328c82db40b2ad03982250b605ef"
        static let clientSecret = "cf571b2013dc4caea30200f220c11a90"
        static let redirectURI = "spotifyclone://"
    }
    
    let spotifyAuthService: SpotifyAuthService
    
    init() {
        spotifyAuthService = SpotifyAuthService(
            clientId: Constants.clientId,
            clientSecret: Constants.clientSecret,
            redirectURI: Constants.redirectURI
        )
    }
}

// MARK: - AppFactory

extension DependencyContainer: AppFactory {
    func makeAppCoordinator(router: Routable) -> AppCoordinator {
        return AppCoordinator(router: router, coordinatorFactory: self, spotifyLoginService: spotifyAuthService)
    }
}

// MARK: - CoordinatorFactory

extension DependencyContainer: CoordinatorFactory {
    func makeWelcomeCoordinator(router: Routable) -> WelcomeCoordinator {
        return WelcomeCoordinator(router: router, screenFactory: self)
    }
    
    func makeAuthCoordinator(router: Routable) -> AuthCoordinator {
        return AuthCoordinator(router: router, screenFactory: self)
    }
    
    func makeMainCoordinator(router: Routable) -> MainCoordinator {
        return MainCoordinator(router: router, coordinatorFactory: self, screenFactory: self)
    }
    
    func makeHomeCoordinator(router: Routable) -> HomeCoordinator {
        return HomeCoordinator(router: router, screenFactory: self)
    }
    
    func makeSearchCoordinator(router: Routable) -> SearchCoordinator {
        return SearchCoordinator(router: router, screenFactory: self)
    }
}

// MARK: - ScreenFactory

extension DependencyContainer: ScreenFactory {
    func makeWelcomeViewController() -> WelcomeViewController {
        let welcomeViewModel = WelcomeViewModel(spotifyAuthService: spotifyAuthService)
        let welcomeViewController = WelcomeViewController(viewModel: welcomeViewModel)
        
        return welcomeViewController
    }
    
    func makeAuthViewController() -> AuthViewController {
        let authViewController = AuthViewController()
        
        return authViewController
    }
    
    func makeMainTabBarController() -> MainTabBarController {
        let mainTabBarController = MainTabBarController()
        
        return mainTabBarController
    }
    
    func makeHomeViewController() -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .green
        
        return viewController
    }
    
    func makeSearchViewController() -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .systemIndigo
        
        return viewController
    }
}
