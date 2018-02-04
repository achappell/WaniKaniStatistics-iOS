//
//  User.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 2/4/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct User: Codable {
    var data: UserData
}

struct UserData: Codable {
    var level: Int
}
