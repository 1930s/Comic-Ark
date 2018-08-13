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
    let appLogo = UIImageView()
    let logoContainer = UIView()
    
    var shouldUpdateLayouts = true
    var isKeyboardVisible = false
    var keyboardFrame = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        appLogo.image = #imageLiteral(resourceName: "Icon")
        appLogo.contentMode = .scaleAspectFit
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoContainer)
        logoContainer.addSubview(appLogo)
        logoContainer.backgroundColor = .clear
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.placeholder = "Your username."
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 0.4)])
        usernameTextField.textColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        usernameTextField.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.7960784314, blue: 0.7019607843, alpha: 0.5)
        usernameTextField.layer.borderWidth = 0.5
        usernameTextField.layer.cornerRadius = 4.0
        usernameTextField.clipsToBounds = true
        usernameTextField.textAlignment = .left
        usernameTextField.keyboardType = .default
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.delegate = self
        view.addSubview(usernameTextField)
        
        emailTextField.placeholder = "Your email address."
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 0.4)])
        emailTextField.textColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        emailTextField.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.7960784314, blue: 0.7019607843, alpha: 0.5)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 4.0
        emailTextField.clipsToBounds = true
        emailTextField.textAlignment = .left
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField.placeholder = "Your password."
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 0.4)])
        passwordTextField.textColor = #colorLiteral(red: 0.2347241044, green: 0.3214844465, blue: 0.4163216352, alpha: 1)
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.7960784314, blue: 0.7019607843, alpha: 0.5)
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 4.0
        passwordTextField.clipsToBounds = true
        passwordTextField.textAlignment = .left
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        passwordConfirmationTextField.placeholder = "Your password again."
        passwordConfirmationTextField.attributedPlaceholder = NSAttributedString(string: passwordConfirmationTextField.placeholder!, attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 0.4)])
        passwordConfirmationTextField.textColor = #colorLiteral(red: 0.2347241044, green: 0.3214844465, blue: 0.4163216352, alpha: 1)
        passwordConfirmationTextField.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.7960784314, blue: 0.7019607843, alpha: 0.5)
        passwordConfirmationTextField.layer.borderWidth = 0.5
        passwordConfirmationTextField.layer.cornerRadius = 4.0
        passwordConfirmationTextField.clipsToBounds = true
        passwordConfirmationTextField.textAlignment = .left
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordConfirmationTextField.borderStyle = .roundedRect
        passwordConfirmationTextField.delegate = self
        view.addSubview(passwordConfirmationTextField)
        
        registrationButton.setTitle("Register", for: .normal)
        registrationButton.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.7254901961, blue: 0.6392156863, alpha: 1)
        registrationButton.layer.cornerRadius = 4.0
        registrationButton.clipsToBounds = true
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
        loginView.textColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        loginView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: #colorLiteral(red: 0.9607843137, green: 0.3647058824, blue: 0.2431372549, alpha: 1)]
        loginView.isEditable = false
        loginView.isSelectable = true
        loginView.delegate = self
        view.addSubview(loginView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update frame and position of all views if keyboard is not visible:
        
        if shouldUpdateLayouts == true {
            registrationButton.isHidden = false
            loginView.isHidden = false
            
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                appLogo.isHidden = false
                
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 50
                
                registrationButton.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                registrationButton.frame.origin.x = view.frame.width / 2 - registrationButton.frame.width / 2
                registrationButton.frame.origin.y = loginView.frame.minY - 40

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
                
                logoContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                logoContainer.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: 0).isActive = true
                logoContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                logoContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                logoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
                appLogo.topAnchor.constraint(equalTo: logoContainer.topAnchor, constant: 0).isActive = true
                appLogo.bottomAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 0).isActive = true
                appLogo.rightAnchor.constraint(equalTo: logoContainer.rightAnchor, constant: 0).isActive = true
                appLogo.leftAnchor.constraint(equalTo: logoContainer.leftAnchor, constant: 0).isActive = true
                appLogo.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor).isActive = true
            } else {
                appLogo.isHidden = true
                
                loginView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                loginView.frame.origin.x = view.frame.width / 2 - loginView.frame.width / 2
                loginView.frame.origin.y = view.frame.maxY - 40
                
                registrationButton.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                registrationButton.frame.origin.x = view.frame.width / 2 - registrationButton.frame.width / 2
                registrationButton.frame.origin.y = loginView.frame.minY - 40
                
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
                
                if error == nil, let registrationData = data {
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
        
        // Update frame and position of all views if keyboard is visible:
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            registrationButton.isHidden = true
            loginView.isHidden = true
            appLogo.isHidden = false
            
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
            appLogo.isHidden = true
            
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

// MARK: - UITextView delegate method:

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Login pressed.")
        dismiss(animated: true, completion: nil)
        return false
    }
}

// MARK: - UITextField delegate methods:

extension RegistrationViewController: UITextFieldDelegate {
    
    // Disable registration button when text fields are empty:
    
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
