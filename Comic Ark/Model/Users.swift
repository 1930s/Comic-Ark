//
//  Users.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 21..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

class Users {
    var publicUsers = [PublicProfile]()
    var filteredUsers = [PublicProfile]()
    var selectedUserCollection = [Comic]()
    
    static let sharedInstance: Users = {
        let instance = Users()
        return instance
    }()
    
    private init() {}
    
    func filterContent(for searchText: String) {
        filteredUsers = publicUsers.filter({ (profile: PublicProfile) -> Bool in
            return profile.name.lowercased().contains(searchText.lowercased())
        })
    }
}


