//
//  LoginViewController.swift
//  
//
//  Created by Wilson Muñoz on 5/2/16.
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //Vars
    let appusers    =    (url:  "https://hackathonappmakescho.firebaseio.com");
    
    //Outlets
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    //Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Radius to Button
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        
        registerForKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        inputEmail.delegate = self
        
        print(self.view.superview?.frame.origin.y)
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
    //Did Layout Subviews
    override func viewDidLayoutSubviews(){
        
        //Add Border to input fields
        let borderEmail = CALayer()
        let borderPassword = CALayer()
        let width = CGFloat(1.0)
        borderEmail.borderColor = UIColor.whiteColor().CGColor
        borderPassword.borderColor = UIColor.whiteColor().CGColor
        borderEmail.frame = CGRect(x: 0, y: inputEmail.frame.size.height - width, width:  inputEmail.frame.size.width, height: inputEmail.frame.size.height)
        borderPassword.frame = CGRect(x: 0, y: inputPassword.frame.size.height - width, width:  inputPassword.frame.size.width, height: inputPassword.frame.size.height)
        
        borderEmail.borderWidth = width
        borderPassword.borderWidth = width
        inputEmail.layer.addSublayer(borderEmail)
        inputEmail.layer.masksToBounds = true
        inputPassword.layer.addSublayer(borderPassword)
        inputPassword.layer.masksToBounds = true
        }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Did Appeared
    override func viewDidAppear(animated: Bool) {
        
        //Hide Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sign In
    @IBAction func SignIn(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(inputEmail.text!, password: inputPassword.text!,
                     completion: { error, authData in
            if error != nil {
                print("No user");
            } else {
                print("All Good");
            }
        })
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print(keyboardFrame)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.superview?.frame.origin.y = -100
        })
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.5, animations:{ () -> Void in
            self.view.superview?.frame.origin.y = 0
            print(self.view.superview?.frame.origin)
        })
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        deregisterFromKeyboardNotifications()
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
