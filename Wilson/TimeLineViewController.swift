//
//  TimeLineViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 7/7/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Firebase
import Spring
import SwiftSpinner
import Alamofire
import AlamofireImage

class TimeLineViewController: UIViewController {
    
    
    //VARS
    var scrollView: UIScrollView!
    var timeline:   TimelineView!
    var images: [TimeFrame] = []
    var eventID: String!
    var image:UIImage?
    
    //Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ButtonSend: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomView.layer.zPosition = 1
        
        //Work Scroll
        scrollView = UIScrollView(frame: topView.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add it
        topView.addSubview(scrollView)
        
        //Add some Constraints
        view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 49),
            NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 40)
            ])
        
         //Call Firebase
         getData()
        
        //Keyboard Delegate
        registerForKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimeLineViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textField.delegate = self
    }
    
    // Keyboard Did Appear
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Keyboard Did Leave
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Generates Elements for Timeline
    func getData(){
        
        //Clean
        self.images.removeAll()
        
        //Get Ref of the selected Event.
        let imagesRef = FIRDatabase.database().reference().child("timeline/\(self.eventID)/").queryOrderedByValue()
        imagesRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            var counter = 0
            let totalelements = snapshot.childrenCount.hashValue
            
            //Check if we have something
            if(snapshot.childrenCount > 0){
                
                //Get SnapShots
                let dataitem = snapshot.value as! Dictionary<String, AnyObject>
                
                //Loop
                for photoid in dataitem{
                    
                    counter += 1
                    
                    let currentID = photoid.0
                    let imagesRefOnTimeline = FIRDatabase.database().reference().child("events/\(self.eventID)/\(currentID)")
                    imagesRefOnTimeline.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        //Order Data
                        let elementinDB = snapshot.value as! [String : AnyObject]
                        
                        //Check type of Data.
                        let type = elementinDB["type"] as! String
                        let content = elementinDB["content"] as! String
                        //let date = elementinDB["date"] as! NSNumber
                        let prettydate = elementinDB["prettydate"] as! String
                        let user = elementinDB["userdisplay"] as! String
                        //let userid = elementinDB["userid"] as! String
                        let fullUserEmail = user.characters.split{$0 == "@"}.map(String.init)
                        
                        if(type == "text"){
                            
                            
                            let element = TimeFrame(text: content, date: "by \(fullUserEmail[0])", image: nil)
                            self.images.append(element)
                            
                        } else {
                            
                            
                            
                            let element = TimeFrame(text: prettydate, date: "by \(fullUserEmail[0])", image: content)
                            self.images.append(element)
                            
                        }
                        
                        if(totalelements == self.images.count){
                            self.createtimeline()
                        }
                        
                    })// Ends imagesRefOnTimeline
                    
                    
                }//Ends for photoid in dataitem
                
                

                
                
            } else {
                
                // No Images, show Alert and go Back
                let alertController = UIAlertController(title: "Stream Empty", message:
                    "Nothing on stream, be the first to share!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                    
                    //Go back.
                    self.performSegueWithIdentifier("goToEvents", sender: self)
                    
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
            imagesRef.removeAllObservers()
            
        })
    
    }
    
    func createtimeline(){
        
        for view in self.scrollView.subviews{
            view.removeFromSuperview()
        }
        
        self.timeline = TimelineView(bulletType: .DiamondSlash, timeFrames: self.images)
        
        //Add Scroll and Constraints
        self.scrollView.addSubview(self.timeline)
        self.scrollView.addConstraints([
            NSLayoutConstraint(item: self.timeline, attribute: .Left, relatedBy: .Equal, toItem: self.scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.timeline, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: 40 ),
            NSLayoutConstraint(item: self.timeline, attribute: .Right, relatedBy: .Equal, toItem: self.scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: self.timeline, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
    }
    
    //Action
    @IBAction func sendMessage(sender: AnyObject) {
        
        //If Input not Empty
        if(self.textField.text != nil) {
            
            //Create Reference
            let storageImagesURL = FIRDatabase.database().reference().child("events/" + self.eventID)
            let storageTimelineURL = FIRDatabase.database().reference().child("timeline/")
            
            //Get Message from Input Text
            let message:String = self.textField.text!
            
            //Get User Data
            var uid = ""
            var displaynameuser = ""
            if let user = FIRAuth.auth()?.currentUser {
                uid = user.uid;
                displaynameuser = user.email!
            }
            
            
            //Get Dates for Range and another for the Timeline
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            let dateFormatterTwo = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            dateFormatterTwo.dateFormat = "MM/dd/yyyy hh:mm:ss"
            let dateString = dateFormatter.stringFromDate(date)
            let dateStringPretty = dateFormatterTwo.stringFromDate(date)
            var dateFinal:NSNumber = 0
            
            var timeStamp = NSDate().timeIntervalSince1970
            timeStamp = 0 - timeStamp

            if let number = Int(dateString) {
                dateFinal = NSNumber(integer:number)
            }
            
            //Insert new Item
            let newitem = storageImagesURL.childByAutoId()
            let newitemkey = newitem.key
            //Create Dic of Data
            let dataFinal: [String: AnyObject] = [
                "date"          : dateFinal,
                "prettydate"    : dateStringPretty,
                "type"          : "text",
                "content"       : message,
                "userid"        : uid,
                "userdisplay"   : displaynameuser
            ]
            newitem.setValue(dataFinal)
            
            
            //Save to Timeline
            let dataTimeline: [String: AnyObject] = [
                "\(self.eventID)/\(newitemkey)": timeStamp
            ]
            storageTimelineURL.updateChildValues(dataTimeline)

//            //Update
//            let dataUpate: [String: AnyObject] = [
//                "events/\(newitem)/date"                : timeStamp,
//                "\(newitem)/prettydate"                 : dateStringPretty,
//                "\(newitem)/type"                       : "text",
//                "\(newitem)/content"                    : message,
//                "\(newitem)/userid"                     : uid,
//                "\(newitem)/userdisplay"                : displaynameuser,
//                "timeline/\(self.eventID)/\(newitem)"   : timeStamp
//            ]
//            //Save Data
//            storageImagesURL.updateChildValues(dataUpate)
            
            
            //Reset input
            self.textField.text = ""
            
            //Clean and Call Firebase
            getData()
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print(keyboardFrame)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.superview?.frame.origin.y = keyboardFrame.height * -1
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TimeLineViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
