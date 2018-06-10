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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        doneButton.isHidden = true

        
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
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
