//
//  MainCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class MainCoordinator: Coordinator {
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

private extension MainCoordinator {
    func showAuthScreen() {
        let authViewController = screenFactory.makeAuthViewController()
        
        router.setRootModule(authViewController)
    }
}
