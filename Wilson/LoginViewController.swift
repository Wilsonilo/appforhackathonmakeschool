//
//  LoginViewController.swift
//  
//
//  Created by Wilson Muñoz on 5/2/16.
//
//

import UIKit
import Firebase
import VideoSplashKit

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Set Radius to Button
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        
        //Check if User is Signed in
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                //User is Signed In
                self.performSegueWithIdentifier("goToEvents", sender: self)
                print(user)

            }//Closes If
        }//Closes FIRAuth.auth()?
    }//Closes Did Load
    
    
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
    
    //User Log In
    @IBAction func SignIn(sender: AnyObject) {
        //Get Data
        let emailuser = inputEmail.text
        let password = inputPassword.text
        
        //Check if Empty
        if(emailuser != "" || password != ""){
            
            FIRAuth.auth()?.signInWithEmail(emailuser!, password: password!) { (user, error) in
                
                //Check if we have any errors.
                if (error == nil){
                    
                    //Declare next View Controller
                    self.performSegueWithIdentifier("goToEvents", sender: self)
                
                //We Have an error.
                } else {
                    
                    //User Not Found or error of login in
                    print("Error login in\(error)")
                    
                } //Else
                
            }//Closes FIRAuth.auth()
        
        } else {
            
            print("run Error empty fields")
        
        }//Else
        
        
    }//IBAction
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}//Ends  Class
