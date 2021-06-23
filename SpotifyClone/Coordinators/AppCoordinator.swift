//
//  AppCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class AppCoordinator: Coordinator {
    private var router: Routable
    
    private var isLoggedIn = false
    
    init(router: Routable) {
        self.router = router
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
        let mainCoordinator = MainCoordinator(router: router)
        
        appendChildCoordinator(mainCoordinator)
        
        mainCoordinator.start()
    }
    
    func startWelcomeFlow() {
        let welcomeCoordinator = WelcomeCoordinator(router: router)
        
        appendChildCoordinator(welcomeCoordinator)
        
        welcomeCoordinator.start()
    }
}
