//
//  AuthentificationResponse.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 06. 02..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

struct AuthentificationResponse: Codable {
    let sessionId: String
    let user: UserResponse
}

struct UserResponse: Codable {
    let isPublic: Bool
    let name: String
}
