//
//  ViewController.swift
//  emailLogin
//
//  Created by ismael alali on 12.9.19.
//  Copyright © 2019 user158383. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailRequired: UILabel!
    @IBOutlet weak var passwordRequired: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar with true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        var keybordlistner = KeyboardAdjustment(scrollView: scrollView)
        //dismiss the keyboard
        scrollView.keyboardDismissMode = .interactive
        
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onLoginPressed() {
        
        
        
        emailRequired.isHidden = true
        passwordRequired.isHidden = true
        
        guard let email = emailTextField.text, email != "" else {
            emailRequired.isHidden = false
            return
        }
        guard let password = passwordTextField.text, password != ""  else {
            passwordRequired.isHidden = false
            return
        }
        setUIForLogin()
        
        
        
        RestCall.shared.login(email: email, pw: password, completionHandler: { (user, error) in
                if let user = user {
                    //move to next page after success login with segue Identifier
                    self.performSegue(withIdentifier: "segueAfterLogin", sender: nil)
                    self.displayLogin(user.displayName)
            
                }
                if let error = error {
                    print(error)
                    self.displayError(error.getErrorString())
                }
            })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setUIBack()
        }
        
    }
    
    func displayLogin(_ name: String) {
        let alert = UIAlertController(title: "Login", message: "Login successful: \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUIForLogin() {
        loadingIndicator.startAnimating()
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
    }
    func setUIBack() {
        loadingIndicator.stopAnimating()
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginButton.isEnabled = true
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return was pressed!")
        textField.resignFirstResponder()
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.onLoginPressed()
        }
        return true
    }
}

