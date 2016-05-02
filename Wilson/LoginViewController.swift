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
    @IBOutlet weak var InputEmail: UITextField!
    @IBOutlet weak var InputPassword: UITextField!
    @IBOutlet weak var ButtonSignIn: UIButton!
    
    
    //Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Radius to Button
        ButtonSignIn.layer.cornerRadius = 20
        ButtonSignIn.clipsToBounds = true

    }
    
    
    //Did Layout Subviews
    override func viewDidLayoutSubviews(){
        
        //Add Border to input fields
        let borderEmail = CALayer()
        let borderPassword = CALayer()
        let width = CGFloat(1.0)
        borderEmail.borderColor = UIColor.whiteColor().CGColor
        borderPassword.borderColor = UIColor.whiteColor().CGColor
        borderEmail.frame = CGRect(x: 0, y: InputEmail.frame.size.height - width, width:  InputEmail.frame.size.width, height: InputEmail.frame.size.height)
        borderPassword.frame = CGRect(x: 0, y: InputPassword.frame.size.height - width, width:  InputPassword.frame.size.width, height: InputPassword.frame.size.height)
        
        borderEmail.borderWidth = width
        borderPassword.borderWidth = width
        InputEmail.layer.addSublayer(borderEmail)
        InputEmail.layer.masksToBounds = true
        InputPassword.layer.addSublayer(borderPassword)
        InputPassword.layer.masksToBounds = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Actions
    @IBAction func SignIn(sender: AnyObject) {
    
    }
    @IBAction func SignUp(sender: AnyObject) {
    }
    

}
