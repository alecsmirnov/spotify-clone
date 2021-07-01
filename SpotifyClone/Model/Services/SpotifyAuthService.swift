//
//  SpotifyAuthService.swift
//  SpotifyClone
//
//  Created by Admin on 01.07.2021.
//

import Foundation

protocol SpotifyAuthServiceProtocol: AnyObject {
    func authorize()
    func fetchAccessToken(from url: URL)
}

final class SpotifyAuthService {
    // MARK: Properties
    
    var openAuthorizeURLCompletion: ((URL) -> Void)?
    
    var isAuthenticated: Bool {
        return session?.isExpired ?? false
    }
    
    private let clientId: String
    private let clientSecret: String
    private let redirectURI: String
    
    private var session: SpotifySession?
    
    // MARK: Init
    
    init(clientId: String, clientSecret: String, redirectURI: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
}

// MARK: - Public Methods

extension SpotifyAuthService: SpotifyAuthServiceProtocol {
    func authorize() {
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
            print("AUTH URL:\n \(authorizeURL)")
            openAuthorizeURLCompletion?(authorizeURL)
        }
    }
    
    func fetchAccessToken(from url: URL) {
        guard
            let authenticationCode = authenticationCode(from: url),
            let request = createRequest(with: authenticationCode)
        else {
            return
        }
        
        RequestBuilder.executeTask(with: request) { data in
            print(data)
        }
    }
}

// MARK: - Helper Methods

private extension SpotifyAuthService {
    func createRequest(with authenticationCode: String) -> URLRequest? {
        let clientString = "\(clientId):\(clientSecret)"
        
        guard let clientData = clientString.data(using: .utf8)?.base64EncodedData() else {
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
}
