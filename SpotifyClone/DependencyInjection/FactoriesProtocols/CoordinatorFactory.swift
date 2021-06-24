//
//  CoordinatorFactory.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

protocol CoordinatorFactory {
    func makeWelcomeCoordinator(router: Routable) -> WelcomeCoordinator
    func makeAuthCoordinator(router: Routable) -> AuthCoordinator
    //func makeMainCoordinator(router: Routable)
}
