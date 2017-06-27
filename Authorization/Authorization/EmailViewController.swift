//
//  EmailViewController.swift
//  Authorization
//
//  Created by Нурлан on 21.06.17.
//  Copyright © 2017 Codebusters. All rights reserved.
//

import UIKit
import UnderKeyboard

private struct Constants {
    static let passwordSegue = "Show Password"
    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

class EmailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - outlet'ы
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet var emailBottomView: UIView!

    private var rightBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.inputAccessoryView
        
        emailTextField.addTarget(self, action: #selector(self.emailTextFieldChanged(_:)), for: UIControlEvents.editingChanged)
        
        rightBarButtonItem = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil
    
        emailTextField.delegate = self
    }
    
    func emailTextFieldChanged(_ textField: UITextField) {
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
        print("debug: textFieldDidBeginEditing")
        emailBottomView.backgroundColor = UIColor.orange
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        print("debug: textFieldDidEndEditing")
        emailBottomView.backgroundColor = UIColor.gray
    }
    
    // MARK: - action'ы
    // показываем страницу с вводом пароля
    @IBAction private func showPassword(_ sender: UIBarButtonItem) {
        
        let email = emailTextField.text!
        if NSPredicate(format:"SELF MATCHES %@", Constants.emailRegEx).evaluate(with: email) {
            performSegue(withIdentifier: Constants.passwordSegue, sender: email)
        } else {
            showAlertWrongEmail()
        }
    }
    // MARK: - сообщение о не правильном email
    private func showAlertWrongEmail() {

        let alert = UIAlertController(title: "Sorry, bro", message: "Incorrect email.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - навигация
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier! {
        case Constants.passwordSegue:
            let destinationVC = segue.destination as! PasswordViewController
            destinationVC.email = sender as! String
        default: break
        }
    }

}
