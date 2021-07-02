//
//  SpotifyAuthService.swift
//  SpotifyClone
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol SpotifyAuthServiceProtocol: AnyObject {
    func authorize(completion: @escaping ((Bool) -> Void))
}

protocol SpotifyLoginServiceProtocol: AnyObject {
    var isLoggedIn: Bool { get }
}

final class SpotifyAuthService {
    // MARK: Properties
    
    var openAuthorizeURLCompletion: ((URL) -> Void)?
    
    var isLoggedIn: Bool {
        return !(session?.isExpired ?? true)
    }
    
    private var session: SpotifySession?
    
    private var authorizeCompletion: ((Bool) -> Void)?
    
    private let clientId: String
    private let clientSecret: String
    private let redirectURI: String
    
    // MARK: Init
    
    init(clientId: String, clientSecret: String, redirectURI: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        
        session = SpotifySession()
    }
}

// MARK: - Public Methods

extension SpotifyAuthService: SpotifyAuthServiceProtocol, SpotifyLoginServiceProtocol {
    func authorize(completion: @escaping ((Bool) -> Void)) {
        guard var authorizeURLComponents = URLComponents(string: SpotifyEndpoint.authorize.urlString) else {
            assertionFailure("Unable to get URL Components")
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "scope", value: "user-read-private user-read-email"),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
        
        authorizeURLComponents.queryItems = queryItems
        
        if let authorizeURL = authorizeURLComponents.url {
            openAuthorizeURLCompletion?(authorizeURL)
        }
        
        authorizeCompletion = completion
    }
    
    func fetchAccessToken(from url: URL) {
        guard
            let authenticationCode = authenticationCode(from: url),
            let request = createRequest(with: authenticationCode)
        else {
            return
        }
        
        RequestBuilder.executeTask(with: request) { [weak self] data in
            guard let authResponse = data?.decode(AuthResponse.self) else {
                DispatchQueue.main.async {
                    self?.authorizeCompletion?(false)
                }
                
                return
            }
            
            self?.session = SpotifySession(with: authResponse)
            
            DispatchQueue.main.async {
                self?.authorizeCompletion?(true)
            }
        }
    }
    
    func refreshAccessToken() {
        guard let request = createRefreshRequest() else { return }
        
        RequestBuilder.executeTask(with: request) { [weak self] data in
            guard let authResponse = data?.decode(AuthResponse.self) else {
                DispatchQueue.main.async {
                    self?.authorizeCompletion?(false)
                }
                
                return
            }
            
            self?.session?.update(with: authResponse)
        }
    }
}

// MARK: - Helper Methods

private extension SpotifyAuthService {
    func authenticationCode(from url: URL) -> String? {
        guard
            let components = URLComponents(string: url.absoluteString),
            let queryItems = components.queryItems
        else {
            assertionFailure("Unable to get URL Components")
            return nil
        }
        
        guard
            let codeItem = queryItems.first(where: { $0.name == "code" }),
            let authenticationCode = codeItem.value
        else {
            if let errorItem = queryItems.first(where: { $0.name == "error" }),
               let error = errorItem.value {
                assertionFailure("Error: \(error)")
            }
            
            return nil
        }
        
        return authenticationCode
    }
    
    func createRequest(with authenticationCode: String) -> URLRequest? {
        let clientString = "\(clientId):\(clientSecret)"
        
        guard let clientData = clientString.data(using: .utf8)?.base64EncodedString() else {
            assertionFailure("Unable to get Data from String")
            return nil
        }
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic \(clientData)"
        ]
        
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "code": authenticationCode,
            "redirect_uri": redirectURI
        ]
        
        guard let request = RequestBuilder.build(
            urlString: SpotifyEndpoint.token.urlString,
            headers: headers,
            parameters: parameters,
            method: .post
        ) else {
            assertionFailure("Unable to build request from URL")
            return nil
        }
        
        return request
    }
    
    func createRefreshRequest() -> URLRequest? {
        guard let refreshToken = session?.refreshToken else { return nil }
        
        let clientString = "\(clientId):\(clientSecret)"
        
        guard let clientData = clientString.data(using: .utf8)?.base64EncodedString() else {
            assertionFailure("Unable to get Data from String")
            return nil
        }
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic \(clientData)"
        ]
        
        let parameters: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        guard let request = RequestBuilder.build(
            urlString: SpotifyEndpoint.token.urlString,
            headers: headers,
            parameters: parameters,
            method: .post
        ) else {
            assertionFailure("Unable to build request from URL")
            return nil
        }
        
        return request
    }
}
