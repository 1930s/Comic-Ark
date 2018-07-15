//
//  RegistrationViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 27..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmationTextField = UITextField()
    let registrationButton = UIButton()
    let loginView = UITextView()
    
    var shouldUpdateLayouts = true
    var isKeyboardVisible = false
    var keyboardFrame = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        usernameTextField.placeholder = "Your username."
        usernameTextField.textAlignment = .left
        usernameTextField.keyboardType = .default
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.delegate = self
        view.addSubview(usernameTextField)
        
        emailTextField.placeholder = "Your email address."
        emailTextField.textAlignment = .left
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField.placeholder = "Your password."
        passwordTextField.textAlignment = .left
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        passwordConfirmationTextField.placeholder = "Re-enter your password."
        passwordConfirmationTextField.textAlignment = .left
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordConfirmationTextField.borderStyle = .roundedRect
        passwordConfirmationTextField.delegate = self
        view.addSubview(passwordConfirmationTextField)
        
        registrationButton.setTitle("Register", for: .normal)
        registrationButton.backgroundColor = UIColor.red
        registrationButton.alpha = 0.5
        registrationButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        view.addSubview(registrationButton)
        registrationButton.isEnabled = false
        
        let text = NSMutableAttributedString(string: "Already a member? ")
        text.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, text.length))
        let selectablePart = NSMutableAttributedString(string: "Login here!")
        selectablePart.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, selectablePart.length))
        selectablePart.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, selectablePart.length))
        selectablePart.addAttribute(NSAttributedStringKey.link, value: "signin", range: NSMakeRange(0, selectablePart.length))
        text.append(selectablePart)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        text.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        loginView.attributedText = text
        loginView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.red]
        loginView.isEditable = false
        loginView.isSelectable = true
        loginView.delegate = self
        view.addSubview(loginView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldUpdateLayouts == true {
            registrationButton.isHidden = false
            loginView.isHidden = false
            
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 50
                
                registrationButton.frame = CGRect(x: view.frame.width / 2 - 100, y: loginView.frame.minY - 30, width: 200, height: 30)
                
                passwordConfirmationTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordConfirmationTextField.frame.origin.x = view.frame.width / 2 - passwordConfirmationTextField.frame.width / 2
                passwordConfirmationTextField.frame.origin.y = registrationButton.frame.minY - 50
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = passwordConfirmationTextField.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            } else {
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 40
                
                registrationButton.frame = CGRect(x: view.frame.width / 2 - 100, y: loginView.frame.minY - 30, width: 200, height: 30)
                
                passwordConfirmationTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordConfirmationTextField.frame.origin.x = view.frame.width / 2 - passwordConfirmationTextField.frame.width / 2
                passwordConfirmationTextField.frame.origin.y = registrationButton.frame.minY - 50
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = passwordConfirmationTextField.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            }
        }
    }
    
    @objc func registerButtonPressed() {
        
        if emailTextField.text!.isValidEmail() && (passwordTextField.text?.count)! > 4 && passwordConfirmationTextField.text! == passwordTextField.text! && (usernameTextField.text?.isEmpty)! == false {
            NetworkManager.register(email: emailTextField.text!, password: passwordTextField.text!, repassword: passwordConfirmationTextField.text!, username: usernameTextField.text!) { (data, error) in
                
                if let registrationData = data {
                    print("Session ID: \(registrationData.sessionId)")

                    NetworkManager.sessionId = registrationData.sessionId
                    
                    User.sharedInstance.name = self.usernameTextField.text!
                    User.sharedInstance.isPublic = true
                    
                    NetworkManager.downloadProfiles { (users, error) in
                        
                        if error == nil {
                            Users.sharedInstance.publicUsers.removeAll()
                            Users.sharedInstance.publicUsers.append(contentsOf: users!)
                        } else {
                            print("Failed to download users.")
                        }
                    }
                    self.performSegue(withIdentifier: "goToMainVCFromRegistration", sender: self)
                } else if let connectionError = error {
                    if connectionError.localizedDescription == "The Internet connection appears to be offline." {
                        let alert = UIAlertController(title: "No internet connection", message: "Make sure that your device is connected to the internet.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        print("Network connection problem.")
                    }
                } else {
                    let alert = UIAlertController(title: "Registration failed", message: "The username or email is already taken.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    print("Username or email is taken.")
                }
            }
        } else {
            if !emailTextField.text!.isValidEmail() {
                let alert = UIAlertController(title: "Registration failed", message: "Invalid email address. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if (passwordTextField.text?.count)! < 4 {
                let alert = UIAlertController(title: "Registration failed", message: "The password should contain at least 5 characters.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if passwordConfirmationTextField.text != passwordTextField.text {
                let alert = UIAlertController(title: "Registration failed", message: "Password confirmation is incorrect. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        
        shouldUpdateLayouts = false
        isKeyboardVisible = true
        
        keyboardFrame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        updateViewFramesWithKeyboard()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            
        }) { (context: UIViewControllerTransitionCoordinatorContext) in
            
            print("Device rotation finished.")
            
            if self.isKeyboardVisible {
                self.updateViewFramesWithKeyboard()
            }
        }
    }
    
    @objc func didTapOnView() {
        
        shouldUpdateLayouts = true
        isKeyboardVisible = false
        
        view.endEditing(true)
        view.setNeedsLayout()
    }
    
    func updateViewFramesWithKeyboard() {
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            registrationButton.isHidden = true
            loginView.isHidden = true
            
            if passwordConfirmationTextField.isEditing {
                passwordConfirmationTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordConfirmationTextField.frame.origin.x = view.frame.width / 2 - passwordConfirmationTextField.frame.width / 2
                passwordConfirmationTextField.frame.origin.y = keyboardFrame.minY - (passwordConfirmationTextField.frame.height + 10)
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = passwordConfirmationTextField.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            } else if passwordTextField.isEditing {
                passwordTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = keyboardFrame.minY - (passwordTextField.frame.height + 10)
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
                
                passwordConfirmationTextField.isHidden = true
            } else if emailTextField.isEditing {
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = keyboardFrame.minY - (emailTextField.frame.height + 10)
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
                
                passwordConfirmationTextField.isHidden = true
                passwordTextField.isHidden = true
            } else {
                usernameTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = keyboardFrame.minY - (usernameTextField.frame.height + 10)
                
                passwordConfirmationTextField.isHidden = true
                passwordTextField.isHidden = true
                emailTextField.isHidden = true
            }
        } else {
            registrationButton.isHidden = true
            loginView.isHidden = true
            
            if passwordConfirmationTextField.isEditing {
                passwordConfirmationTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordConfirmationTextField.frame.origin.x = view.frame.width / 2 - passwordConfirmationTextField.frame.width / 2
                passwordConfirmationTextField.frame.origin.y = keyboardFrame.minY - (passwordConfirmationTextField.frame.height + 10)
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = passwordConfirmationTextField.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            } else if passwordTextField.isEditing {
                passwordConfirmationTextField.isHidden = true
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = keyboardFrame.minY - (passwordTextField.frame.height + 10)
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            } else if emailTextField.isEditing {
                passwordConfirmationTextField.isHidden = true
                passwordTextField.isHidden = true
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = keyboardFrame.minY - (emailTextField.frame.height + 10)
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = emailTextField.frame.minY - 50
            } else {
                passwordConfirmationTextField.isHidden = true
                passwordTextField.isHidden = true
                emailTextField.isHidden = true
                
                usernameTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                usernameTextField.frame.origin.x = view.frame.width / 2 - usernameTextField.frame.width / 2
                usernameTextField.frame.origin.y = keyboardFrame.minY - (usernameTextField.frame.height + 10)
            } 
        }
    }
}

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("Login pressed.")
        dismiss(animated: true, completion: nil)
        
        return false
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if (passwordTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordConfirmationTextField.text?.isEmpty)! {
            registrationButton.isEnabled = false
            registrationButton.alpha = 0.5
        } else {
            registrationButton.isEnabled = true
            registrationButton.alpha = 1
        }
        
        usernameTextField.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        passwordConfirmationTextField.isHidden = false
        
        return true
    }
}
