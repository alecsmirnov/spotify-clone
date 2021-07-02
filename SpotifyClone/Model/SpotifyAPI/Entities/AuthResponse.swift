//
//  AuthResponse.swift
//  SpotifyClone
//
//  Created by Admin on 01.07.2021.
//

import Foundation

struct AuthResponse {
    let accessToken: String
    let expiresIn: Int
    var refreshToken: String?
    let scope: String
    let tokenType: String
}

// MARK: - Decodable

extension AuthResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case tokenType = "token_type"
    }
}
