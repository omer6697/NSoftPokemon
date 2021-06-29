//
//  ViewController.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/27/21.
//

import UIKit
import Network

class AuthVC: UIViewController, UIConfigurationProtocol {

    let monitor = NWPathMonitor()
    
    lazy var titleLabel = UILabel.newLabel("Welcome", true, .black, 20)
    lazy var usernameLabel = UILabel.newLabel("Please enter your username:", false, .black, 15)
    lazy var usernameTextField = UITextField.newTextField("Tap to start typing", false)
    lazy var continueButton = UIButton.newButton("Continue", .red)
    lazy var signInContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        checkForInternetConnection()
    }

    internal func setupUI() {
        print("setupUI called")
        setNavigation()
        addSubviews()
        setConstraints()
        addButtonAction()
        checkUsernameInKeychain()
    }
    
    internal func setNavigation() {
        view.backgroundColor = .tertiarySystemBackground
        navigationController?.isNavigationBarHidden = true
    }
    
    internal func addSubviews() {
        view.addSubview(signInContainer)
        signInContainer.translatesAutoresizingMaskIntoConstraints = false
        
        signInContainer.addSubview(titleLabel)
        signInContainer.addSubview(usernameLabel)
        signInContainer.addSubview(usernameTextField)
        signInContainer.addSubview(continueButton)
    }
    
    internal func setConstraints() {
        NSLayoutConstraint.activate([
            signInContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInContainer.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: signInContainer.topAnchor, constant: 20),
            
            usernameLabel.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 30),
            
            continueButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 50),
            continueButton.leadingAnchor.constraint(equalTo: signInContainer.leadingAnchor, constant: 10),
            continueButton.trailingAnchor.constraint(equalTo: signInContainer.trailingAnchor, constant: -10),
            continueButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    internal func addButtonAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc func continueButtonTapped() {
        if usernameTextField.text == "" || usernameTextField.text!.count <= 3 {
            UIAlertController.showCustomAlert(for: self, title: "Username invalid", message: "Username is required field. It must have more than 3 characters!", actionTitle: "OK")
        }
        print("continueButtonTapped called")
        saveUsernameToKeychain()
        navigationController?.pushViewController(HomeVC(), animated: true)
    }
    
    // Add notification observer to observe internet connection
    // Show alert if device is not connected to internet
}

//MARK: - Working with Keychain
extension AuthVC {
    internal func saveUsernameToKeychain() {
        guard usernameTextField.text != "" && usernameTextField.text!.count > 3 else { return }
        KeychainWrapper.standard.set(usernameTextField.text!, forKey: "UsernameKeychain")
        usernameTextField.resignFirstResponder()
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
    }
    
    internal func checkUsernameInKeychain() {
        if let username = KeychainWrapper.standard.string(forKey: "UsernameKeychain") {
            usernameTextField.text = username
            if UserDefaults.standard.bool(forKey: "UserLoggedIn") {
                navigationController?.pushViewController(HomeVC(), animated: true)
            }
        }
    }
}

extension AuthVC {
    private func showCustomAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
