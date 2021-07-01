//
//  SpotifyClientData.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

struct SpotifyClientData {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}

// MARK: - Decodable

extension SpotifyClientData: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
