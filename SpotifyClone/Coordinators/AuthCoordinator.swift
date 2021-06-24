//
//  AuthCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class AuthCoordinator: Coordinator {
    private var router: Routable
    private var screenFactory: ScreenFactory
    
    init(router: Routable, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showAuthScreen()
    }
}

private extension AuthCoordinator {
    func showAuthScreen() {
        let authViewController = screenFactory.makeAuthViewController()
        
        router.setRootModule(authViewController)
    }
}
