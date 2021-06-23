//
//  WelcomeCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class WelcomeCoordinator: Coordinator {
    private var router: Routable
    
    private var isLoggedIn = false
    
    init(router: Routable) {
        self.router = router
    }
    
    override func start() {
        showWelcomeScreen()
    }
}

private extension WelcomeCoordinator {
    func showWelcomeScreen() {
        let welcomeViewController = WelcomeViewController()
        
        router.setRootModule(welcomeViewController)
    }
}
