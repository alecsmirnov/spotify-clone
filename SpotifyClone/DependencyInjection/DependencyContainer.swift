//
//  DependencyContainer.swift
//  SpotifyClone
//
//  Created by Admin on 24.06.2021.
//

import Foundation

final class DependencyContainer {
    
}

// MARK: - AppFactory

extension DependencyContainer: AppFactory {
    func makeAppCoordinator(router: Routable) -> AppCoordinator {
        return AppCoordinator(router: router, coordinatorFactory: self)
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
}

// MARK: - ScreenFactory

extension DependencyContainer: ScreenFactory {
    func makeWelcomeViewController() -> WelcomeViewController {
        let welcomeViewController = WelcomeViewController()
        
        return welcomeViewController
    }
    
    func makeAuthViewController() -> AuthViewController {
        let authViewController = AuthViewController()
        
        return authViewController
    }
}
