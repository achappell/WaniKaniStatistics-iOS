//
//  API.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation
import Hyperspace

class API: NSObject, URLSessionDelegate {
    
    static let shared: API = API()
    var session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    let baseURL = "https://api.wanikani.com/v2"
    let apiToken = "17d53a38-37a5-42bc-a2bd-19de03a318ef"
    private let backendService = BackendService()

    func user(completion: @escaping ((User) -> Void)) {
        if let url = URL(string: "\(baseURL)/user") {
            let headers: [HTTP.HeaderKey: HTTP.HeaderValue] = [.authorization: .authorizationBearer(token: apiToken)]
            let request = AnyRequest<UserContainer>(method: .get, url: url, headers: headers, cachePolicy: .reloadIgnoringLocalCacheData)
            
            self.backendService.execute(request: request) { result in
                switch result {
                case .success(let response):
                    completion(response.data)
                    debugPrint(response)
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
    }
    
    func levelProgressions(id: Int? = nil, completion: @escaping (([LevelProgression]) -> Void)) {
        if let url = URL(string: "\(baseURL)/level_progressions") {
            let headers: [HTTP.HeaderKey: HTTP.HeaderValue] = [.authorization: .authorizationBearer(token: apiToken)]
            let request = AnyRequest<Container<LevelProgression>>(method: .get, url: url, headers: headers, cachePolicy: .reloadIgnoringLocalCacheData)
            
            self.backendService.execute(request: request) { result in
                switch result {
                case .success(let response):
                    completion(response.data.map({ (data) -> LevelProgression in
                                        return data.data
                                  }))
                    debugPrint(response)
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
    }
    
    func assignments(level: Int, completion: @escaping ((Container<Assignment>) -> Void)) {
        if let url = URL(string: "\(baseURL)/assignments?srs_stages=\(level)") {
            let headers: [HTTP.HeaderKey: HTTP.HeaderValue] = [.authorization: .authorizationBearer(token: apiToken)]
            let request = AnyRequest<Container<Assignment>>(method: .get, url: url, headers: headers, cachePolicy: .reloadIgnoringLocalCacheData)
            
            self.backendService.execute(request: request) { result in
                switch result {
                case .success(let response):
                    completion(response)
                    debugPrint(response)
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
    }
    
    func summary(completion: @escaping ((Summary) -> Void)) {
        if let url = URL(string: "\(baseURL)/summary") {
            let headers: [HTTP.HeaderKey: HTTP.HeaderValue] = [.authorization: .authorizationBearer(token: apiToken)]
            let request = AnyRequest<ContainerData<Summary>>(method: .get, url: url, headers: headers, cachePolicy: .reloadIgnoringLocalCacheData)
            
            self.backendService.execute(request: request) { result in
                switch result {
                case .success(let response):
                    completion(response.data)
                    debugPrint(response)
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }
        }
    }
}

