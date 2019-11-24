//
//  ResponseError.swift
//  emailLogin
//
//  Created by user158383 on 10/8/19.
//  Copyright © 2019 user158383. All rights reserved.
//

struct ResponseError: Codable {
    var error: Error
}

struct Error: Codable {
    var code: Int
    var message: String
    var errors: [NestedError]
}

struct NestedError: Codable {
    var message: String
    var domain: String
    var reason: String
}
