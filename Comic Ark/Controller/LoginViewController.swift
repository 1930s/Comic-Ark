//
//  LoginViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 27..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let registrationView = UITextView()
    
    var shouldUpdateLayouts = true
    var isKeyboardVisible = false
    var keyboardFrame = CGRect()
    
    let appLogo = UIImageView()
    let logoContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        if let loadedData = UserDefaults.standard.object(forKey: "ValidEmail") as? String {
            print("Loaded valid email: \(loadedData)")
            emailTextField.text = loadedData
        }
        
        appLogo.image = #imageLiteral(resourceName: "Icon")
        appLogo.contentMode = .scaleAspectFit
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoContainer)
        logoContainer.addSubview(appLogo)
        logoContainer.backgroundColor = .clear
        logoContainer.translatesAutoresizingMaskIntoConstraints = false

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
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.7960784314, blue: 0.7019607843, alpha: 1)
        loginButton.layer.cornerRadius = 4.0
        loginButton.clipsToBounds = true
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
        registrationView.textColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        registrationView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: #colorLiteral(red: 0.9607843137, green: 0.3647058824, blue: 0.2431372549, alpha: 1)]
        registrationView.isEditable = false
        registrationView.isSelectable = true
        registrationView.delegate = self
        view.addSubview(registrationView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldUpdateLayouts = true
        view.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update frame and position of all views if keyboard is not visible:
        
        if shouldUpdateLayouts == true {
            loginButton.isHidden = false
            registrationView.isHidden = false
            
            emailTextField.isHidden = false
            passwordTextField.isHidden = false
            
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                registrationView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                registrationView.frame.origin.x = view.frame.width / 2 - registrationView.frame.width / 2
                registrationView.frame.origin.y = view.frame.maxY - 50
                
                loginButton.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                loginButton.frame.origin.x = view.frame.width / 2 - loginButton.frame.width / 2
                loginButton.frame.origin.y = registrationView.frame.minY - 40
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = loginButton.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
            } else {
                registrationView.frame.size = CGSize(width: view.frame.width - 30, height: 25)
                registrationView.frame.origin.x = view.frame.width / 2 - registrationView.frame.width / 2
                registrationView.frame.origin.y = view.frame.maxY - 40
                
                loginButton.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                loginButton.frame.origin.x = view.frame.width / 2 - loginButton.frame.width / 2
                loginButton.frame.origin.y = registrationView.frame.minY - 40
                
                passwordTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = loginButton.frame.minY - 50
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
            }
            
            logoContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            logoContainer.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 0).isActive = true
            logoContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            logoContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            logoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            appLogo.topAnchor.constraint(equalTo: logoContainer.topAnchor, constant: 0).isActive = true
            appLogo.bottomAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 0).isActive = true
            appLogo.rightAnchor.constraint(equalTo: logoContainer.rightAnchor, constant: 0).isActive = true
            appLogo.leftAnchor.constraint(equalTo: logoContainer.leftAnchor, constant: 0).isActive = true
            appLogo.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor).isActive = true
        }
    }
    
    @objc func loginButtonPressed() {
        if emailTextField.text!.isValidEmail() {
            NetworkManager.login(email: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
                
                if let loginData = data {
                    print("Session ID: \(loginData.sessionId)")
                    print("Hardware ID: \(UIDevice.current.identifierForVendor!.uuidString)")

                    NetworkManager.sessionId = loginData.sessionId
                    User.sharedInstance.name = loginData.user.name
                    User.sharedInstance.isPublic = loginData.user.isPublic
                    
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
                        if error == nil, let loadedUsers = users {
                            Users.sharedInstance.publicUsers.removeAll()
                            Users.sharedInstance.publicUsers.append(contentsOf: loadedUsers)
                        } else {
                            if let error = error {
                                print(error)
                            }
                            print("Failed to download users.")
                        }
                    }
                    self.performSegue(withIdentifier: "goToMainVCFromLogin", sender: self)
                } else {
                    if let connectionError = error {
                        if connectionError.localizedDescription == "The Internet connection appears to be offline." {
                            let alert = UIAlertController(title: "No internet connection", message: "Make sure that your device is connected to the internet.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true)
                            print("Network connection problem.")
                        }
                    } else {
                        let alert = UIAlertController(title: "Authentification failed", message: "Invalid email or password. Please try again.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        print("Authentification failed.")
                    }
                }
            }
        } else {
            if !emailTextField.text!.isValidEmail() {
                let alert = UIAlertController(title: "Login failed", message: "Invalid email address. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if (passwordTextField.text?.count)! < 4 {
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
    
    // Update frame and position of all views if keyboard is visible:
    
    func updateViewFramesWithKeyboard() {
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            loginButton.isHidden = true
            registrationView.isHidden = true
            
            if passwordTextField.isEditing {
                passwordTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = keyboardFrame.minY - (passwordTextField.frame.height + 10)
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
            } else {
                passwordTextField.isHidden = true
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 70, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = keyboardFrame.minY - (emailTextField.frame.height + 10)
            }
        } else {
            loginButton.isHidden = true
            registrationView.isHidden = true
            
            if passwordTextField.isEditing {
                passwordTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                passwordTextField.frame.origin.x = view.frame.width / 2 - passwordTextField.frame.width / 2
                passwordTextField.frame.origin.y = keyboardFrame.minY - (passwordTextField.frame.height + 10)
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = passwordTextField.frame.minY - 50
            } else {
                passwordTextField.isHidden = true
                
                emailTextField.frame.size = CGSize(width: view.frame.width - 100, height: 35)
                emailTextField.frame.origin.x = view.frame.width / 2 - emailTextField.frame.width / 2
                emailTextField.frame.origin.y = keyboardFrame.minY - (emailTextField.frame.height + 10)
            }
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

// MARK: - UITextView delegate methods:

extension LoginViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        performSegue(withIdentifier: "goToRegistration", sender: self)
        return false
    }
}

// MARK: - UITextField delegate methods:

extension LoginViewController: UITextFieldDelegate {
    
    // Disable login button when text fields are empty.
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (passwordTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        } else {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        }
        passwordTextField.isHidden = false
        passwordTextField.isHidden = false
        return true
    }
}
