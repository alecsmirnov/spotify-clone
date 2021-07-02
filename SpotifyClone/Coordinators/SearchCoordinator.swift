//
//  SearchCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 02.07.2021.
//

import Foundation

final class SearchCoordinator: Coordinator {
    private let router: Routable
    private let screenFactory: ScreenFactory
    
    init(router: Routable, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showSearchScreen()
    }
}

private extension SearchCoordinator {
    func showSearchScreen() {
        let searchViewController = screenFactory.makeSearchViewController()
        
        router.setRootModule(searchViewController)
    }
}
