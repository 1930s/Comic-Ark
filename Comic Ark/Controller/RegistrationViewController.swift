//
//  RegistrationViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 27..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    let appLogo = UIImageView()
    let emailField = UITextField()
    let passwordField = UITextField()
    let passwordConfirmationField = UITextField()
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
        
        passwordConfirmationField.placeholder = "Re-enter your password."
        passwordConfirmationField.textAlignment = .left
        passwordConfirmationField.isSecureTextEntry = true
        passwordConfirmationField.borderStyle = .roundedRect
        passwordConfirmationField.delegate = self
        view.addSubview(passwordConfirmationField)
        
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
        
        if shouldUpdateLayouts == true {
            
            appLogo.isHidden = false
            registrationButton.isHidden = false
            loginView.isHidden = false
            
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                
                appLogo.frame = CGRect(x: view.frame.width / 2 - 50, y: 40, width: 100, height: 100)
                
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 50
                
                registrationButton.frame = CGRect(x: view.frame.width / 2 - 100, y: loginView.frame.minY - 30, width: 200, height: 30)
                
                passwordConfirmationField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordConfirmationField.frame.origin.x = view.frame.width / 2 - passwordConfirmationField.frame.width / 2
                passwordConfirmationField.frame.origin.y = registrationButton.frame.minY - 50
                
                passwordField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
                passwordField.frame.origin.y = passwordConfirmationField.frame.minY - 50
                
                emailField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
                emailField.frame.origin.y = passwordField.frame.minY - 50
                
            } else {
                
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 40
                
                registrationButton.frame = CGRect(x: view.frame.width / 2 - 100, y: loginView.frame.minY - 30, width: 200, height: 30)
                
                passwordConfirmationField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordConfirmationField.frame.origin.x = view.frame.width / 2 - passwordConfirmationField.frame.width / 2
                passwordConfirmationField.frame.origin.y = registrationButton.frame.minY - 50
                
                passwordField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
                passwordField.frame.origin.y = passwordConfirmationField.frame.minY - 50
                
                emailField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
                emailField.frame.origin.y = passwordField.frame.minY - 50
                
                appLogo.frame = CGRect(x: emailField.frame.minX, y: 20, width: 50, height: 50)
            }
        }
    }
    
    @objc func registerButtonPressed() {
        
        if emailField.text!.isValidEmail() && (passwordField.text?.count)! > 4 && passwordConfirmationField.text! == passwordField.text! {
            
            NetworkManager.register(email: emailField.text!, password: passwordField.text!, repassword: passwordConfirmationField.text!) { (data, error) in
                
                if let registrationData = data {
                    print("Session ID: \(registrationData.sessionId)")

                    NetworkManager.sessionId = registrationData.sessionId
                    
                    self.performSegue(withIdentifier: "goToMainVCFromRegistration", sender: self)
                } else {
                    print("Registration failed.")
                }
            }
            
            
            
        } else {
            
            if !emailField.text!.isValidEmail() {
                let alert = UIAlertController(title: "Registration failed", message: "Invalid email address. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if (passwordField.text?.count)! < 4 {
                let alert = UIAlertController(title: "Registration failed", message: "The password should contain at least 5 characters.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if passwordConfirmationField.text != passwordField.text {
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
            registrationButton.isHidden = true
            loginView.isHidden = true
            
            appLogo.frame = CGRect(x: view.frame.width / 2 - 50, y: 40, width: 100, height: 100)
            
            passwordConfirmationField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
            passwordConfirmationField.frame.origin.x = view.frame.width / 2 - passwordConfirmationField.frame.width / 2
            passwordConfirmationField.frame.origin.y = keyboardFrame.minY - (passwordConfirmationField.frame.height + 10)
            
            passwordField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
            passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
            passwordField.frame.origin.y = passwordConfirmationField.frame.minY - 50
            
            emailField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
            emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
            emailField.frame.origin.y = passwordField.frame.minY - 50
            
        } else {
            
            appLogo.isHidden = true
            registrationButton.isHidden = true
            loginView.isHidden = true
            
            passwordConfirmationField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
            passwordConfirmationField.frame.origin.x = view.frame.width / 2 - passwordConfirmationField.frame.width / 2
            passwordConfirmationField.frame.origin.y = keyboardFrame.minY - (passwordConfirmationField.frame.height + 10)
            
            passwordField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
            passwordField.frame.origin.x = view.frame.width / 2 - passwordField.frame.width / 2
            passwordField.frame.origin.y = passwordConfirmationField.frame.minY - 50
            
            emailField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
            emailField.frame.origin.x = view.frame.width / 2 - emailField.frame.width / 2
            emailField.frame.origin.y = passwordField.frame.minY - 50
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
        if (passwordField.text?.isEmpty)! || (emailField.text?.isEmpty)! || (passwordConfirmationField.text?.isEmpty)! {
            registrationButton.isEnabled = false
            registrationButton.alpha = 0.5
        } else {
            registrationButton.isEnabled = true
            registrationButton.alpha = 1
        }
        
        return true
    }
}
