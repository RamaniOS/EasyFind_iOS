//
//  APIManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Alamofire

class APIManager {
    
    private static let apiKey = "H7_n0PCOUjVZEMUpa1HCeC6LFPts3LXArEZbjpURqiis-40Cu3wQER1SAENdf4t08Td08hODQQMinYB4U97GpJ4vMptJHQdOz1ELeONy7KxyiQiBB1aLyHUJBczOXXYx"
    
    private static var manager: Alamofire.SessionManager = {
        // Get the default headers
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        // Add the Authorization header
        headers["Authorization"] = "Bearer \(apiKey)"
        // Create a custom session configuration
        let configuration = URLSessionConfiguration.default
        // Add the Authorization header
        configuration.httpAdditionalHeaders = headers
        // Create a session manager with the custom configuration
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    public static func requestWith<T: Codable>(_ url: URLConvertible, parameters: Parameters? = nil, requestType: HTTPMethod? = .get, completion: @escaping (T?) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            manager.request(url, method: requestType!, parameters: parameters).responseData { (response) in
                if let data = response.data {
                    let model = try? JSONDecoder().decode(T.self, from: data)
                    completion(model)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
