//
//  WelcomeViewModel.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

protocol WelcomeViewModelProtocol: AnyObject {
    func signIn()
}

final class WelcomeViewModel {
    private let spotifyAPI: SpotifyAPIProtocol
    
    init(spotifyAPI: SpotifyAPIProtocol) {
        self.spotifyAPI = spotifyAPI
    }
}

// MARK: - WelcomeViewModelProtocol

extension WelcomeViewModel: WelcomeViewModelProtocol {
    func signIn() {
        spotifyAPI.signIn()
    }
}
