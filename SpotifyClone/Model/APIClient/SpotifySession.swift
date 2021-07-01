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
    
    var accessToken: String {
        return clientData.accessToken
    }
    
    var refreshToken: String {
        return clientData.refreshToken
    }
    
    var expiresIn: Int {
        return clientData.expiresIn
    }
    
    private var expirationDate: Date {
        return Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    private let clientData: SpotifyClientData
    
    // MARK: Constants
    
    private enum Constants {
        static let sessionKey = "SpotifySession"
    }
    
    // MARK: Init
    
    init(with clientData: SpotifyClientData) {
        self.clientData = clientData
    }
}

// MARK: - Private Methods

//private extension SpotifySession {
//    func save() {
//        let encoder = JSONEncoder()
//        
//        if let encode = try? encoder.encode(self) {
//            UserDefaults.standard.setValue(encode, forKey: Constants.sessionKey)
//        } else {
//            assertionFailure("Unable to parse JSON")
//        }
//    }
//    
//    static func load() -> SpotifySession? {
//        var session: SpotifySession?
//        
//        if let savedSession = UserDefaults.standard.object(forKey: Constants.sessionKey) as? Data {
//            let decoder = JSONDecoder()
//            
//            if let loadedSession = try? decoder.decode(SpotifySession.self, from: savedSession) {
//                session = loadedSession
//            } else {
//                assertionFailure("Unable to parse JSON")
//            }
//        }
//        
//        return session
//    }
//}

// MARK: - Codable

//extension SpotifySession: Codable {}
