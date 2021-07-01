//
//  RequestBuilder.swift
//  SpotifyClone
//
//  Created by Admin on 01.07.2021.
//

import Foundation

enum RequestBuilder {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}

// MARK: - Public Methods

extension RequestBuilder {
    static func build(
        urlString: String,
        headers: [String: String] = [:],
        parameters: [String: String] = [:],
        method: HTTPMethod
    ) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            assertionFailure("Unable to build request from URL string")
            return nil
        }
        
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = components.query?.data(using: .utf8)
        
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    static func executeTask(with request: URLRequest, completion: @escaping ((Data?) -> Void)) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                assertionFailure("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                assertionFailure("Warning, status code: \(response.statusCode)")
                return
            }
            
            completion(data)
        }
        
        task.resume()
    }
}
