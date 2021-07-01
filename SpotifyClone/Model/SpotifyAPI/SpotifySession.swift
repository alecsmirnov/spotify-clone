//
//  SpotifySession.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

struct SpotifySession: Codable {
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
    
    init(with authResponse: AuthResponse) {
        self.accessToken = authResponse.accessToken
        self.refreshToken = authResponse.refreshToken
        self.expiresIn = authResponse.expiresIn
        
        SpotifySession.save(self)
    }
    
    init?() {
        guard let session = SpotifySession.load() else { return nil }
        
        self = session
    }
}

// MARK: - Helper Methods

private extension SpotifySession {
    static func save(_ session: SpotifySession) {
        let encoder = JSONEncoder()
        
        if let encode = try? encoder.encode(session) {
            UserDefaults.standard.setValue(encode, forKey: key)
        } else {
            assertionFailure("Unable to save data")
        }
    }
    
    static func load() -> SpotifySession? {
        var session: SpotifySession?
        
        if let savedSession = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            
            if let loadedSession = try? decoder.decode(SpotifySession.self, from: savedSession) {
                session = loadedSession
            } else {
                assertionFailure("Unable to load data")
            }
        }
        
        return session
    }
}
