//
//  SettingsViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 18..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var isPublicSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.sharedInstance.isPublic {
            isPublicSwitch.isOn = true
        } else {
            isPublicSwitch.isOn = false
        }
        
        usernameField.text = User.sharedInstance.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        doneButton.isHidden = true
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        if sender.isOn {
            User.sharedInstance.isPublic = true
        } else {
            User.sharedInstance.isPublic = false
        }
        
        NetworkManager.editProfile(name: usernameField.text!, isPublic: User.sharedInstance.isPublic) { (confirmation, error) in
            if error == nil, let editConfirmation = confirmation {
                print("Profile has been updated: \(String(describing: editConfirmation["success"]))")
            } else {
                print("Failed to update profile.")
            }
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        
        if let username = usernameField.text {
            
            NetworkManager.editProfile(name: username, isPublic: User.sharedInstance.isPublic) { (confirmation, error) in
                if error == nil, let editConfirmation = confirmation {
                    print("Profile has been updated: \(String(describing: editConfirmation["success"]))")
                } else {
                    print("Failed to update profile.")
                }
            }
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
        NetworkManager.logout { (confirmation, error) in
            if error == nil, let logoutConfirmation = confirmation {
                print("User has logged out: \(String(describing: logoutConfirmation["success"]))")
                self.view.endEditing(true)
                User.sharedInstance.collection.removeAll()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                print("Failed to log out.")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete Profile", message: "Do you want to permanently delete your profile? All your data will be lost.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            NetworkManager.deleteProfile(completion: { (confirmation, error) in

                if error == nil {
                    print("Account has been deleted.")
                    self.view.endEditing(true)
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isHidden = true
    }
}
