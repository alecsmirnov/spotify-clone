//
//  MainCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

final class MainCoordinator: Coordinator {
    private var router: Routable
    
    private var isLoggedIn = false
    
    init(router: Routable) {
        self.router = router
    }
    
    override func start() {
        showAuthScreen()
    }
}

private extension MainCoordinator {
    func showAuthScreen() {
        let authViewController = AuthViewController()
        
        router.setRootModule(authViewController)
    }
}
