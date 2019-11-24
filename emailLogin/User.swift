//
//  User.swift
//  emailLogin
//
//  Created by user158383 on 10/8/19.
//  Copyright © 2019 user158383. All rights reserved.
//

struct User: Codable {
    var kind: String
    var localId: String
    var email: String
    var displayName: String
    var idToken: String
    var registered: Bool
    var refreshToken: String
    var expiresIn: String
}
