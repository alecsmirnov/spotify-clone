//
//  ScreenFactory.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

protocol ScreenFactory {
    func makeWelcomeViewController() -> WelcomeViewController
    func makeAuthViewController() -> AuthViewController
    //func makeMainViewController() -> MainViewController
}
