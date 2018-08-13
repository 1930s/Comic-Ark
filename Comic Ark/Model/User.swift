//
//  User.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance: User = {
        let instance = User()
        return instance
    }()
    
    private init() {}
    
    var name = String() {
        didSet {
            UserDefaults.standard.setValue(name, forKey: "username")
        }
    }
    var collection = [Comic]()
    var isPublic: Bool = true {
        didSet {
            UserDefaults.standard.setValue(isPublic, forKey: "isPublic")
        }
    }
    
    func addToCollection(comic: Comic) {
        if !collection.contains(where: { (item) -> Bool in
            item.isbn == comic.isbn
        }) {
            collection.insert(comic, at: 0)
        }   
    }
    
    func update() {
        if let loadedUsername = UserDefaults.standard.object(forKey: "username") as? String {
            name = loadedUsername
        }
        if let loadedIsPublic = UserDefaults.standard.object(forKey: "isPublic") as? Bool {
            isPublic = loadedIsPublic
        }
    }
}
