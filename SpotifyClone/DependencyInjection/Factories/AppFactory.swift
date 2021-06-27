//
//  AppFactory.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

protocol AppFactory {
    func makeAppCoordinator(router: Routable) -> AppCoordinator
}
