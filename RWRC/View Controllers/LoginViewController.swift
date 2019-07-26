/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: Constants
    //let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      // 1
      Auth.auth().addStateDidChangeListener() { auth, user in
        // 2
        if user != nil {
          // 3
          //self.performSegue(withIdentifier: self.loginToList, sender: nil)
          self.textFieldLoginEmail.text = nil
          self.textFieldLoginPassword.text = nil
        }
      }
      
      //registerForKeyboardNotifications()
    }
  
//  private func registerForKeyboardNotifications() {
//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(keyboardWillShow(_:)),
//      name: UIResponder.keyboardWillShowNotification,
//      object: nil
//    )
//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(keyboardWillHide(_:)),
//      name: UIResponder.keyboardWillHideNotification,
//      object: nil
//    )
//  }
//
//  @objc private func keyboardWillShow(_ notification: Notification) {
//    guard let userInfo = notification.userInfo else {
//      return
//    }
//    guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
//      return
//    }
//    guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
//      return
//    }
//    guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
//      return
//    }
//
//    let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
//    bottomConstraint.constant = keyboardHeight + 20
//
//    UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
//      self.view.layoutIfNeeded()
//    }, completion: nil)
//  }
//
//  @objc private func keyboardWillHide(_ notification: Notification) {
//    guard let userInfo = notification.userInfo else {
//      return
//    }
//    guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
//      return
//    }
//    guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
//      return
//    }
//
//    let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
//    bottomConstraint.constant = 20
//
//    UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
//      self.view.layoutIfNeeded()
//    }, completion: nil)
//  }
  
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
      guard
        let email = textFieldLoginEmail.text,
        let password = textFieldLoginPassword.text,
        email.count > 0,
        password.count > 0
        else {
          return
      }
      
      Auth.auth().signIn(withEmail: email, password: password) { user, error in
        if let error = error, user == nil {
          let alert = UIAlertController(title: "Sign In Failed",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          
          self.present(alert, animated: true, completion: nil)
        }
      }
      
      guard let name = textFieldLoginEmail.text, !name.isEmpty else {
        print("Oh no!")
        return
      }
      
      AppSettings.displayName = name
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                    message: "Register",
                                    preferredStyle: .alert)
      
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
        // 1
        let emailField = alert.textFields![0]
        let passwordField = alert.textFields![1]
        // 2
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
          if error == nil {
            // 3
            Auth.auth().signIn(withEmail: emailField.text!,
                               password: passwordField.text!)
          }
        }
          
      }
      
      let cancelAction = UIAlertAction(title: "Cancel",
                                       style: .cancel)
      
      //let nameField = alert.textFields![2]
      
      alert.addTextField { textEmail in
        textEmail.placeholder = "Enter your email"
      }
      
      alert.addTextField { textPassword in
        textPassword.isSecureTextEntry = true
        textPassword.placeholder = "Enter your password"
      }
    
//      alert.addTextField { textName in
//        textName.placeholder = "Enter your name"
//
//      }
      
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
      
      //textFieldLoginEmail.resignFirstResponder()
      //alert.textFields![2].resignFirstResponder()
      
      
      //AppSettings.displayName = textFieldLoginEmail.text
      print("TEXT FIELD")
      print(textFieldLoginEmail.text)
      guard let name = textFieldLoginEmail.text, !name.isEmpty else {
        print("Oh no!")
        return
      }
      
      AppSettings.displayName = name
    }
    
  }


extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
}
