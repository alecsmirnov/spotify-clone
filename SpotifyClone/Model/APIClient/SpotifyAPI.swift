//
//  SpotifyAPI.swift
//  SpotifyClone
//
//  Created by Admin on 27.06.2021.
//

import Foundation

//protocol SpotifyAPIDelegate: AnyObject {
//    func spotifyAPIOpenURL(_ sporifyAPI: SpotifyAPIProtocol, _ url: URL)
//}
//
//protocol SpotifyAPIProtocol: AnyObject {
//    func signIn()
//}
//
//final class SpotifyAPI {
//    // MARK: Properties
//    
//    weak var delegate: SpotifyAPIDelegate?
//    
//    private(set) var session: SpotifySession?
//    
//    private var authorizeURL: URL? {
//        guard var urlComponents = URLComponents(string: SpotifyEndpoint.authorize.urlString) else { return nil }
//        
//        let queryItems = [
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "client_id", value: manager.clientId),
//            URLQueryItem(name: "scope", value: "user-read-private user-read-email"),
//            URLQueryItem(name: "redirect_uri", value: manager.redirectURI)
//        ]
//        
//        urlComponents.queryItems = queryItems
//        
//        return urlComponents.url
//    }
//    
//    private let manager: SpotifyManager
//    
//    // MARK: Init
//    
//    init(with spotifyManager: SpotifyManager) {
//        manager = spotifyManager
//    }
//}
//
//// MARK: - Public Methods
//
//extension SpotifyAPI: SpotifyAPIProtocol {
//    func signIn() {
//        guard let authorizeURL = authorizeURL else { return }
//        
//        delegate?.spotifyAPIOpenURL(self, authorizeURL)
//    }
//}
