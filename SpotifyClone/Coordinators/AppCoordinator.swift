//
//  AppCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class AppCoordinator: Coordinator {
    private let router: Routable
    private let coordinatorFactory: CoordinatorFactory
    
    private let spotifyLoginService: SpotifyLoginServiceProtocol
    
    init(router: Routable, coordinatorFactory: CoordinatorFactory, spotifyLoginService: SpotifyLoginServiceProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        
        self.spotifyLoginService = spotifyLoginService
    }
    
    override func start() {
        if spotifyLoginService.isLoggedIn {
            startMainFlow()
        } else {
            startWelcomeFlow()
        }
    }
}

// MARK: - Flow Methods

private extension AppCoordinator {
    func startMainFlow() {
        // TODO: replace with MainCoordinator
        let mainCoordinator = coordinatorFactory.makeAuthCoordinator(router: router)
        
        appendChildCoordinator(mainCoordinator)
        
        mainCoordinator.start()
    }
    
    func startWelcomeFlow() {
        let welcomeCoordinator = coordinatorFactory.makeWelcomeCoordinator(router: router)
        
        welcomeCoordinator.finishFlow = { [weak self, weak welcomeCoordinator] success in
            guard success else { return }
            
            self?.start()
            self?.removeChildCoordinator(welcomeCoordinator)
        }
        
        appendChildCoordinator(welcomeCoordinator)
        
        welcomeCoordinator.start()
    }
}
