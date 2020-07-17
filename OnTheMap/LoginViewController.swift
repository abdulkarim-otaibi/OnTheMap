//
//  ViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 19/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //bordor color
        emailTextField.setColorBordor()
        passwordTextField.setColorBordor()
      

    }
    

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         subscribeToKeyboardNotifications()
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         unsubscribeFromKeyboardNotifications()
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
    @IBAction func SignUp(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
                   UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               }
    }
    @IBAction func login(_ sender: Any) {
     
     guard  let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "", password != "" else {
                self.showAlert(title: "Missing information", message: "Please fill both fields and try again")
                return
        }
        let load = self.startAnActivityIndicator()
        API.postSession(username: emailTextField.text!, password: passwordTextField.text!) { (errString) in
            
            load.stopAnimating()
            guard errString == nil else {
                self.showAlert(title: "Error", message: errString!)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        }

    }
    

}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let textField = UIResponder.currentFirstResponder as? UITextField else { return }
        let keyboardHeight = getKeyboardHeight(notification)
        
        // kbMinY is minY of the keyboard rect
        let kbMinY = (view.frame.height-keyboardHeight)
        
        // Check if the current textfield is covered by the keyboard
        var bottomCenter = textField.center
        bottomCenter.y += textField.frame.height/2
        let textFieldMaxY = textField.convert(bottomCenter, to: self.view).y
        if textFieldMaxY - kbMinY > 0 {
            
            // Displace the view's origin by the difference between kb's minY and textfield's maxY
            view.frame.origin.y = -(textFieldMaxY - kbMinY)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notifition: Notification) -> CGFloat {
        let userInfo = notifition.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

extension UIResponder {
    
    private static weak var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        
        return _currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

extension UITextField {
    func setColorBordor(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5;
    }
}



