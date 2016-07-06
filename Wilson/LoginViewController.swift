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
    
    //Did Appear
    override func viewDidAppear(animated: Bool) {
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
}
