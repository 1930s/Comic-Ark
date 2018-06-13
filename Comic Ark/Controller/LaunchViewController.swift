//
//  LaunchViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 06. 09..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.checkLoggedInState { (state, error) in
            
            if error == nil {
                if state!["isLoggedIn"] == true {
                    
                    NetworkManager.downloadBooks { (comics, error) in
                        
                        if let loadedComics = comics {
                            for comic in loadedComics {
                                User.sharedInstance.addToCollection(comic: comic)
                            }
                        } else {
                            print("Failed to download domics.")
                        }
                    }
                    
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
