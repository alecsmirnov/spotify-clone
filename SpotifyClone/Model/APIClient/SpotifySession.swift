//
//  SpotifySession.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

struct SpotifySession {
    // MARK: Properties
    
    var isExpired: Bool {
        return expirationDate < Date()
    }
    
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    private var expirationDate: Date {
        return Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    // MARK: Init
    
    init(accessToken: String, refreshToken: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}

// MARK: - Decodable

extension SpotifySession: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
