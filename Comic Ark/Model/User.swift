//
//  User.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

class User {
    private var name = String()
    private var password = String()
    private var email = String()
    var collection = [Comic]()
    
    var isPrivate: Bool = false
    
    var sessionId = String()
    
    static let sharedInstance: User = {
        let instance = User()
        return instance
    }()
    
    func addToCollection(comic: Comic) {
        
        if !collection.contains(where: { (item) -> Bool in
            item.isbn == comic.isbn
        }) {
            collection.insert(comic, at: 0)
        }   
    }
    private init() {}
}
