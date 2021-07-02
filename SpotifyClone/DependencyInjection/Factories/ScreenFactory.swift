//
//  ScreenFactory.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

// TODO: Remove
import UIKit

protocol ScreenFactory {
    func makeWelcomeViewController() -> WelcomeViewController
    func makeAuthViewController() -> AuthViewController
    
    func makeMainTabBarController() -> MainTabBarController
    func makeHomeViewController() -> UIViewController
    func makeSearchViewController() -> UIViewController
}
