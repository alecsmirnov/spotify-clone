//
//  WelcomeCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class WelcomeCoordinator: Coordinator {
    private var router: Routable
    private var screenFactory: ScreenFactory
    
    init(router: Routable, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showWelcomeScreen()
    }
}

private extension WelcomeCoordinator {
    func showWelcomeScreen() {
        let welcomeViewController = screenFactory.makeWelcomeViewController()
        
        router.setRootModule(welcomeViewController)
    }
}
