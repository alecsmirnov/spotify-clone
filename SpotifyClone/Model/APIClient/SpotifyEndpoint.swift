//
//  SpotifyEndpoint.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

enum SpotifyEndpoint {
    case authorize
}

extension SpotifyEndpoint {
    var urlString: String {
        let urlString: String
        
        switch self {
        case .authorize:
            urlString = "https://accounts.spotify.com/authorize"
        }
        
        return urlString
    }
}
