//
//  API.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct API {

    func levelProgressions(id: Int? = nil, completion: (([LevelProgression]) -> Void)?) {
        if let url = URL(string: "https://www.wanikani.com/api/v2/level_progressions") {
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.setValue("Bearer 7df922d8-9af6-4763-90c9-aae6db0baee6", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                let decoder = JSONDecoder()
                do {
                    if let data = data {
                        let levelProgression = try decoder.decode(LevelProgressions.self, from: data)
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            completion?(levelProgression.data.map({ (data) -> LevelProgression in
                                return data.data
                            }))
                        })
                    }
                } catch let myError {
                    print("caught: \(myError)")
                }
            }.resume()
        }
    }

}

