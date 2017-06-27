 //
//  PasswordViewController.swift
//  Authorization
//
//  Created by Нурлан on 21.06.17.
//  Copyright © 2017 Codebusters. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private struct Constants {
    static let userInfoSegue = "Show User Info"
}

class PasswordViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    // MARK: - переменные
    var email: String!
    private var rightBarButtonItem: UIBarButtonItem!
    
    // MARK: - outlet'ы
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.addTarget(self, action: #selector(self.passwordTextFieldChanged(_:)), for: UIControlEvents.editingChanged)
        
        rightBarButtonItem = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
        
        passwordTextField.delegate = self
    }
    
    func passwordTextFieldChanged(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0 {
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        print("debug: passwordDidBeginEditing")
        passwordBottomView.backgroundColor = UIColor.orange
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        print("debug: passwordDidEndEditing")
        passwordBottomView.backgroundColor = UIColor.gray
    }
    
    @IBAction private func authorize(_ sender: UIBarButtonItem) {
        let password = passwordTextField.text!
        
        // проверка на правильность пароля(минимум 4 символов)
        if password.characters.count >= 4 {
            startAnimating()
            // запрос на сервак
            User.authorize(email: email, password: password) { user, message in
                self.stopAnimating()
                
                if let message = message {
                    print(message)
                    self.showAlert(title: "Sorry, bro", message: message)
                } else {
                    self.performSegue(withIdentifier: Constants.userInfoSegue,
                                      sender: user!)
                }
            }
        } else {
            self.showAlert(title: "Sorry, bro", message: "Incorrect password format")
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    // MARK: - навигация
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Constants.userInfoSegue:
            let destinationVC = segue.destination as! TokenInfoViewController
            destinationVC.user = sender as! User
        default: break
        }
    }
    
}
