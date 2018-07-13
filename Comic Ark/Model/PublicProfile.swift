//
//  PublicProfile.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 07. 06..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

struct PublicProfile: Codable {
    let id: Int
    var name: String
    let email: String
    var bookCount: Int
}
