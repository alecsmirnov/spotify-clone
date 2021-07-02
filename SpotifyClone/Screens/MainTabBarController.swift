//
//  MainTabBarController.swift
//  SpotifyClone
//
//  Created by Admin on 02.07.2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }
}

// MARK: - Appearance

private extension MainTabBarController {
    func setupAppearance() {
        tabBar.tintColor = UIColor.black
    }
}
