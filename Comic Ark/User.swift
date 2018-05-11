//
//  User.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

class User {
    var name = String()
    var password = String()
    var collection = [Comic]()
    var isPrivate: Bool = false
    
    static let sharedInstance: User = {
        let instance = User()
        return instance
    }()
    
    private init() {}
}
