//
//  LaunchViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 06. 09..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedSessionId = UserDefaults.standard.object(forKey: "sessionId") as? String {
            NetworkManager.sessionId = savedSessionId
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if user is logged in and if true then segue to PrivateCollectionViewController and download data from server, otherwise segue to LoginViewController:
        
        NetworkManager.checkLoggedInState { (state, error) in
            if error == nil {
                if state!["isLoggedIn"] == true {

                    print("Downloading comics...")

                    NetworkManager.downloadPrivateCollection { (comics, error) in
                        if error == nil, let loadedComics = comics {
                            for comic in loadedComics {
                                comic.downloadImage()
                                User.sharedInstance.addToCollection(comic: comic)
                            }
                        } else {
                            if let error = error {
                                print(error)
                            }
                            print("Failed to download comics.")
                        }
                    }
                    
                    NetworkManager.downloadProfiles { (users, error) in
                        if error == nil, let downloadedUsers = users {
                            Users.sharedInstance.publicUsers.removeAll()
                            Users.sharedInstance.publicUsers.append(contentsOf: downloadedUsers)
                        } else {
                            if let error = error {
                                print(error)
                            }
                            print("Failed to download users.")
                        }
                    }
                    
                    User.sharedInstance.update()
                    
                    self.performSegue(withIdentifier: "goToMainVC", sender: self)
                } else {
                    self.performSegue(withIdentifier: "goToLoginVC", sender: self)
                }
            } else {
                self.performSegue(withIdentifier: "goToLoginVC", sender: self)
            }
        }
    }
}
