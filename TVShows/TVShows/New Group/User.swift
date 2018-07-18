//
//  User.swift
//  TVShows
//
//  Created by Filip Gulan on 11/07/2018.
//  Copyright © 2018 Filip Gulan. All rights reserved.
//

import Foundation

struct User: Codable { /* typealias Codable = Encodable & Decodable */
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginUser: Codable {
    let token: String
}
