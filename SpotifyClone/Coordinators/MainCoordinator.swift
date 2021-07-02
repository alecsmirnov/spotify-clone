//
//  MainCoordinator.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let router: Routable
    private let coordinatorFactory: CoordinatorFactory
    private let screenFactory: ScreenFactory
    
    init(router: Routable, coordinatorFactory: CoordinatorFactory, screenFactory: ScreenFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showTabBarScreen()
    }
}

private extension MainCoordinator {
    func showTabBarScreen() {
        let mainTabBarController = screenFactory.makeMainTabBarController()
        
        let (homeNavigationController, homeCoordinator) = setupHimeCoordinator()
        let (searchNavigationController, searchCoordinator) = setupSearchCoordinator()
        
        mainTabBarController.viewControllers = [homeNavigationController, searchNavigationController]
        
        appendChildCoordinator(homeCoordinator)
        appendChildCoordinator(searchCoordinator)
        
        router.setRootModule(mainTabBarController)
        
        homeCoordinator.start()
        searchCoordinator.start()
    }
}

private extension MainCoordinator {
    func setupHimeCoordinator() -> (UINavigationController, HomeCoordinator) {
        let homeNavigationController = UINavigationController()
        let homeRouter = Router(rootController: homeNavigationController)
        let homeCoordinator = coordinatorFactory.makeHomeCoordinator(router: homeRouter)
        
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        
        return (homeNavigationController, homeCoordinator)
    }
    
    func setupSearchCoordinator() -> (UINavigationController, SearchCoordinator) {
        let searchNavigationController = UINavigationController()
        let searchRouter = Router(rootController: searchNavigationController)
        let searchCoordinator = coordinatorFactory.makeSearchCoordinator(router: searchRouter)
        
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        
        return (searchNavigationController, searchCoordinator)
    }
}
