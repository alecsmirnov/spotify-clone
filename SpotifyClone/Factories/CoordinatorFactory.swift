//
//  CoordinatorFactory.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import Foundation

protocol CoordinatorFactory {
    func createWelcomeCoordinator(router: Routable)
    func createAuthCoordinator(router: Routable)
}

