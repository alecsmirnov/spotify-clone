//
//  WelcomeViewModel.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

protocol WelcomeViewModelProtocol: AnyObject {
    func signIn(completion: @escaping ((Bool) -> Void))
}

final class WelcomeViewModel {
    private let spotifyAuthService: SpotifyAuthServiceProtocol
    
    init(spotifyAuthService: SpotifyAuthServiceProtocol) {
        self.spotifyAuthService = spotifyAuthService
    }
}

// MARK: - WelcomeViewModelProtocol

extension WelcomeViewModel: WelcomeViewModelProtocol {
    func signIn(completion: @escaping ((Bool) -> Void)) {
        spotifyAuthService.authorize(completion: completion)
    }
}
