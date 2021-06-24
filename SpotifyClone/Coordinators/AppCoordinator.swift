//
//  AppCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class AppCoordinator: Coordinator {
    private var router: Routable
    private var coordinatorFactory: CoordinatorFactory
    
    private var isLoggedIn = false
    
    init(router: Routable, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        if isLoggedIn {
            startMainFlow()
        } else {
            startWelcomeFlow()
        }
    }
}

private extension AppCoordinator {
    func startMainFlow() {
        // TODO: replace with MainCoordinator
        let mainCoordinator = coordinatorFactory.makeAuthCoordinator(router: router)
        
        appendChildCoordinator(mainCoordinator)
        
        mainCoordinator.start()
    }
    
    func startWelcomeFlow() {
        let welcomeCoordinator = coordinatorFactory.makeWelcomeCoordinator(router: router)
        
        appendChildCoordinator(welcomeCoordinator)
        
        welcomeCoordinator.start()
    }
}
