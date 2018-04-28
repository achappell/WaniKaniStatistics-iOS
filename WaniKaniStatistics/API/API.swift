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

    func user(completion: @escaping ((User) -> Void)) {
        if let url = URL(string: "\(baseURL)/user") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: UserContainer.self, completion: { (user) in
                completion(user.data)
            })
        }
    }
    
    func levelProgressions(id: Int? = nil, completion: @escaping (([LevelProgression]) -> Void)) {
        if let url = URL(string: "\(baseURL)/level_progressions") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: Container<LevelProgression>.self, completion: { (levelProgressions) in
                completion(levelProgressions.data.map({ (data) -> LevelProgression in
                    return data.data
                }))
            })
        }
    }
    
    func assignments(level: Int, completion: @escaping ((Container<Assignment>) -> Void)) {
        if let url = URL(string: "\(baseURL)/assignments?srs_stages=\(level)") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: Container<Assignment>.self, completion: { (assignments) in
                completion(assignments)
            })
        }
    }
    
    func summary(completion: @escaping ((Summary) -> Void)) {
        if let url = URL(string: "\(baseURL)/summary") {
            let urlRequest = urlRequestWithAuthorization(url: url)
            
            apiCall(request: urlRequest, decoderClass: ContainerData<Summary>.self, completion: { (summary) in
                completion(summary.data)
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

