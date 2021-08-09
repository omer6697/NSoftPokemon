//
//  ViewController.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/27/21.
//

import UIKit
import SnapKit

class AuthVC: UIViewController, UIConfigurationProtocol {
    
    lazy var titleLabel = UILabel.newLabel("Welcome", true, .black, 20)
    lazy var usernameLabel = UILabel.newLabel("Please enter your username:", false, .black, 15)
    lazy var usernameTextField = UITextField.newTextField("Tap to start typing", false)
    lazy var continueButton = UIButton.newButton("Continue", .red)
    lazy var signInContainer = UIView()
    
    private let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    internal func setupUI() {
        print("setupUI called")
        setNavigation()
        addSubviews()
        setConstraints()
        addButtonAction()
        checkUsernameInKeychain()
        addDoneBtnOnKeyboard()
        removeKeyboard()
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
            signInContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            signInContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signInContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: signInContainer.topAnchor, constant: 40),
            
            usernameLabel.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 60),
            
            continueButton.bottomAnchor.constraint(equalTo: signInContainer.bottomAnchor),
            continueButton.leadingAnchor.constraint(equalTo: signInContainer.leadingAnchor, constant: 10),
            continueButton.trailingAnchor.constraint(equalTo: signInContainer.trailingAnchor, constant: -10),
            continueButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    internal func addButtonAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func removeKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func addDoneBtnOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.usernameTextField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func continueButtonTapped() {
        debugPrint("continueButtonTapped called")
        if usernameTextField.text == "" || usernameTextField.text!.count <= 3 {
            UIAlertController.showCustomAlert(for: self, title: "Username invalid", message: "Username is required field. It must have more than 3 characters!", actionTitle: "OK")
        } else {
            saveUsernameToKeychain()
            viewModel.saveUsernameToKeychain(username: usernameTextField.text, key: "UsernameKeychain")
            navigationController?.pushViewController(HomeVC(), animated: true)
        }
    }
}

//MARK: - Working with Keychain
extension AuthVC {
    internal func saveUsernameToKeychain() {
        guard usernameTextField.text != "" && usernameTextField.text!.count > 3 else { return }
        KeychainWrapper.standard.set(usernameTextField.text!, forKey: "UsernameKeychain")
        usernameTextField.resignFirstResponder()
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
        viewModel.saveUsernameToKeychain(username: usernameTextField.text, key: "UsernameKeychain")
    }
    
    internal func checkUsernameInKeychain() {
        viewModel.checkUsernameInKeychain(for: self, key: "UsernameKeychain") { [weak self] username in
            guard let self = self else { return }
            self.usernameTextField.text = username
            self.navigationController?.pushViewController(HomeVC(), animated: true)
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
