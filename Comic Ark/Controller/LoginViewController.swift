//
//  LoginViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 27..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let appLogo = UIImageView()
    let emailField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton()
    let registrationView = UITextView()
    
    var shouldUpdateLayouts = true
    var isKeyboardVisible = false
    var keyboardFrame = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        if let loadedData = UserDefaults.standard.object(forKey: "ValidEmail") as? String {
            print("Loaded valid email: \(loadedData)")
            emailField.text = loadedData
        }
        
        appLogo.image = UIImage()
        appLogo.contentMode = .scaleAspectFit
        view.addSubview(appLogo)
        
        emailField.placeholder = "Your email address."
        emailField.textAlignment = .left
        emailField.keyboardType = .emailAddress
        emailField.borderStyle = .roundedRect
        emailField.delegate = self
        view.addSubview(emailField)
        
        passwordField.placeholder = "Your password."
        passwordField.textAlignment = .left
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.delegate = self
        view.addSubview(passwordField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.red
        loginButton.alpha = 0.5
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        loginButton.isEnabled = false
        
        let text = NSMutableAttributedString(string: "Not a member? ")
        text.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, text.length))
        let selectablePart = NSMutableAttributedString(string: "Register here!")
        selectablePart.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, selectablePart.length))
        selectablePart.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, selectablePart.length))
        selectablePart.addAttribute(NSAttributedStringKey.link, value: "signin", range: NSMakeRange(0, selectablePart.length))
        text.append(selectablePart)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        text.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        registrationView.attributedText = text
        registrationView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.red]
        registrationView.isEditable = false
        registrationView.isSelectable = true
        registrationView.delegate = self
        view.addSubview(registrationView)
    }
    
    override func viewDidLayoutSubviews() {
        
        if shouldUpdateLayouts == true {
            
            loginButton.isHidden = false
            registrationView.isHidden = false
            
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                
                registrationView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                registrationView.frame.origin.x = view.frame.width / 2 - registrationView.frame.width / 2
                registrationView.frame.origin.y = view.frame.maxY - 50
                
                loginButton.frame = CGRect(x: view.frame.width / 2 - 100, y: registrationView.frame.minY - 30, width: 200, height: 30)
                
                passwordField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
                passwordField.frame.origin.y = loginButton.frame.minY - 50
                
                emailField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
                emailField.frame.origin.y = passwordField.frame.minY - 50
                
            } else {
                
                appLogo.frame = CGRect(x: view.frame.width / 2 - 25, y: 20, width: 50, height: 50)
                
                registrationView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                registrationView.frame.origin.x = view.frame.width / 2 - registrationView.frame.width / 2
                registrationView.frame.origin.y = view.frame.maxY - 40
                
                loginButton.frame = CGRect(x: view.frame.width / 2 - 100, y: registrationView.frame.minY - 30, width: 200, height: 30)
                
                passwordField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
                passwordField.frame.origin.y = loginButton.frame.minY - 50
                
                emailField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
                emailField.frame.origin.y = passwordField.frame.minY - 50
            }
        }
    }
    
    @objc func loginButtonPressed() {
        
        if emailField.text!.isValidEmail() {
            
            NetworkManager.login(email: emailField.text!, password: passwordField.text!) { (data, error) in
                if let loginData = data {
                    print("Session ID: \(loginData.sessionId)")
                    print("Hardware ID: \(UIDevice.current.identifierForVendor!.uuidString)")

                    NetworkManager.sessionId = loginData.sessionId
                    
                    self.performSegue(withIdentifier: "goToMainVCFromLogin", sender: self)
                    
                } else {
                    print("Login failed.")
                }
            }
            
            
            
            
        } else {
            
            if !emailField.text!.isValidEmail() {
                let alert = UIAlertController(title: "Login failed", message: "Invalid email address. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if (passwordField.text?.count)! < 4 {
                let alert = UIAlertController(title: "Login failed", message: "The password should contain at least 5 characters.", preferredStyle: .alert)
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
            
            print("Rotation finished.")
            
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
            
            appLogo.isHidden = false
            loginButton.isHidden = true
            registrationView.isHidden = true
            
            appLogo.frame = CGRect(x: view.frame.width / 2 - 50, y: 40, width: 100, height: 100)
            
            passwordField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
            passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
            passwordField.frame.origin.y = keyboardFrame.minY - (passwordField.frame.height + 10)
            
            emailField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
            emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
            emailField.frame.origin.y = passwordField.frame.minY - 50
            
        } else {
            
            loginButton.isHidden = true
            registrationView.isHidden = true
            
            passwordField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
            passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
            passwordField.frame.origin.y = keyboardFrame.minY - (passwordField.frame.height + 10)
            
            emailField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
            emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
            emailField.frame.origin.y = passwordField.frame.minY - 50
            
            appLogo.frame = CGRect(x: view.frame.width / 2 - 25, y: emailField.frame.minY - 60, width: 50, height: 50)
        }
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension LoginViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("Registration pressed.")
        
        performSegue(withIdentifier: "goToRegistration", sender: self)
        
        return false
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (passwordField.text?.isEmpty)! || (emailField.text?.isEmpty)! {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        } else {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        }
        
        return true
    }
}
