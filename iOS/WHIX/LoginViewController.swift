//
//  SecondViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    lazy var functions = Functions.functions(region:"europe-west1")

    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func onLoginClicked(_ sender: Any) {
        checkBtnStatus()
        
        print("enabled: \(loginBtn.isEnabled)")
        
        if !loginBtn.isEnabled {
            return
        }
        
        print("calling backend")
        
        functions.httpsCallable("login").call([
            "email": emailField.text!,
            "username": usernameField.text!,
        ]) { (result, error) in
            if let error = error as NSError? {
                print(error)
                return
            }
            
            if let userId = result?.data as? String {
                UserDefaults.standard.set(userId, forKey: "loggedInUserId")
                UserDefaults.standard.set(self.usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "loggedInUsername")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("failed login :/")
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 5
        loginBtn.clipsToBounds = true
        
        emailField.delegate = self
        usernameField.delegate = self
        
        checkBtnStatus()
        
        emailField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func checkBtnStatus() {
        if emailField.text!.isEmpty || !emailField.text!.contains("@") {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor(hue:0.98, saturation:0.53, brightness:0.54, alpha:1.00)
            return
        }
        
        if usernameField.text!.isEmpty {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor(hue:0.98, saturation:0.53, brightness:0.54, alpha:1.00)
            return
        }
        
        loginBtn.isEnabled = true
        loginBtn.backgroundColor = UIColor(hue:0.98, saturation:0.83, brightness:0.74, alpha:1.00)
        
        return
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            textField.resignFirstResponder()
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            onLoginClicked(textField)
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        checkBtnStatus()
    }

}

