//
//  WelcomeCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class WelcomeCoordinator: Coordinator {
    // MARK: Properties
    
    var finishFlow: ((Bool) -> Void)?
    
    private var router: Routable
    private var screenFactory: ScreenFactory
    
    // MARK: Init
    
    init(router: Routable, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showWelcomeScreen()
    }
}

// MARK: - Flow Methods

private extension WelcomeCoordinator {
    func showWelcomeScreen() {
        let welcomeViewController = screenFactory.makeWelcomeViewController()
        welcomeViewController.onWelcomeCompletion = { [weak self] success in
            self?.finishFlow?(success)
        }
        
        router.setRootModule(welcomeViewController)
    }
}
