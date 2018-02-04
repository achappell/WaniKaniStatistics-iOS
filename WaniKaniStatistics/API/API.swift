//
//  API.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct API {
    
    let baseURL = "https://www.wanikani.com/api/v2"

    func user(completion: @escaping ((UserData) -> Void)) {
        if let url = URL(string: "\(baseURL)/user") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: User.self, completion: { (user) in
                completion(user.data)
            })
        }
    }
    
    func levelProgressions(id: Int? = nil, completion: @escaping (([LevelProgressionData]) -> Void)) {
        if let url = URL(string: "\(baseURL)/level_progressions") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: LevelProgressions.self, completion: { (levelProgressions) in
                completion(levelProgressions.data.map({ (data) -> LevelProgressionData in
                    return data.data
                }))
            })
        }
    }
}

extension API {
    
    func apiCall<T: Codable>(request: URLRequest, decoderClass: T.Type, completion: @escaping (T) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
            do {
                if let data = data {
                    let object = try decoder.decode(decoderClass, from: data)
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        completion(object)
                    })
                }
            } catch let myError {
                print("caught: \(myError)")
            }
            }.resume()
    }
    
    func urlRequestWithAuthorization(url: URL) -> URLRequest {
        var urlRequest: URLRequest = URLRequest(url: url)
        addAuthorizationHeader(request: &urlRequest)
        return urlRequest
    }
    
    func addAuthorizationHeader(request: inout URLRequest) {
        request.setValue("Bearer 7df922d8-9af6-4763-90c9-aae6db0baee6", forHTTPHeaderField: "Authorization")
    }
}

