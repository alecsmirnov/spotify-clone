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
    
    private(set) var accessToken: String
    private(set) var refreshToken: String
    private(set) var expiresIn: Int
    
    private var expirationDate: Date {
        return Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    // MARK: Constants
    
    private static let key = String(describing: Self.self)
    
    // MARK: Init
    
    init?(with authResponse: AuthResponse) {
        guard let refreshToken = authResponse.refreshToken else { return nil }
        
        self.accessToken = authResponse.accessToken
        self.refreshToken = refreshToken
        self.expiresIn = authResponse.expiresIn
        
        SpotifySession.save(self)
    }
    
    init?() {
        guard let session = SpotifySession.load() else { return nil }
        
        self = session
    }
}

// MARK: - Public Methods

extension SpotifySession {
    mutating func update(with authResponse: AuthResponse) {
        self.accessToken = authResponse.accessToken
        self.expiresIn = authResponse.expiresIn
        
        SpotifySession.save(self)
    }
}

// MARK: - Helper Methods

private extension SpotifySession {
    static func save(_ session: SpotifySession) {
        KeychainWrapper.setValue(session, forKey: key)
    }
    
    static func load() -> SpotifySession? {
        return KeychainWrapper.object(forKey: key)
    }
}

// MARK: - Codable

extension SpotifySession: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
