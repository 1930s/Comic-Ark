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
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2901960784, green: 0.7254901961, blue: 0.6392156863, alpha: 1)
    }
    
    func presentConnectionErrorAlert() {
        let alert = UIAlertController(title: "No internet connection", message: "Make sure that your device is connected to the internet.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
        print("Network connection problem.")
    }
    
    func updateUserDetails() {
        NetworkManager.editProfile(name: User.sharedInstance.name, isPublic: User.sharedInstance.isPublic) { (confirmation, error) in
            if error == nil, let editingConfirmation = confirmation, editingConfirmation["success"] == true {
                print("Profile has been successfully updated.")
                
                NetworkManager.downloadProfiles { (users, error) in
                    if error == nil, let downloadedUsers = users {
                        Users.sharedInstance.publicUsers.removeAll()
                        Users.sharedInstance.publicUsers.append(contentsOf: downloadedUsers)
                    } else {
                        print("Failed to download users.")
                    }
                }
            } else {
                print("Failed to update profile.")
                self.presentConnectionErrorAlert()
            }
        }
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            User.sharedInstance.isPublic = true
        } else {
            User.sharedInstance.isPublic = false
        }
        updateUserDetails()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        updateUserDetails()
    }
    
    func logOut() {
        NetworkManager.logout { (confirmation, error) in
            if error == nil, let logoutConfirmation = confirmation, logoutConfirmation["success"] == true {
                print("User has been successfully logged out.")
                self.view.endEditing(true)
                User.sharedInstance.collection.removeAll()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                if let error = error {
                    print(error)
                }
                print("Failed to log out.")
            }
            print("Network connection problem.")
            self.presentConnectionErrorAlert()
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        logOut()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Profile", message: "Are you sure you want to permanently delete your profile? All your data will be lost.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            
            NetworkManager.deleteProfile(completion: { (confirmation, error) in
                if error == nil, let deleteConfirmation = confirmation, deleteConfirmation["success"] == true {
                    print("User has been successfully deleted.")
                    self.logOut()
                } else {
                    print("Failed to delete profile.")
                    self.presentConnectionErrorAlert()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

// MARK: - UITextField delegate methods:

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isHidden = true
        User.sharedInstance.name = textField.text ?? ""
    }
}
