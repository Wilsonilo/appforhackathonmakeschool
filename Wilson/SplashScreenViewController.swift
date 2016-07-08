//
//  SplashViewController.swift
//  Wilson
//
//  Created by Mehul Ajith on 7/5/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController, HolderViewDelegate {
    
    var holderView = HolderView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if User is Signed in
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                
                //User is Signed In
                self.performSegueWithIdentifier("goToEventsSplash", sender: self)
                print(user)
                
            }//Closes If
        }//Closes FIRAuth.auth()?
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 70)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Freebo."
        label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: ({
                                    label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
                                   }), completion: { finished in
        })
    }
    
}

