//
//  HomeCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 02.07.2021.
//

import Foundation

final class HomeCoordinator: Coordinator {
    private let router: Routable
    private let screenFactory: ScreenFactory
    
    init(router: Routable, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showHomeScreen()
    }
}

private extension HomeCoordinator {
    func showHomeScreen() {
        let homeViewController = screenFactory.makeHomeViewController()
        
        router.setRootModule(homeViewController)
    }
}
