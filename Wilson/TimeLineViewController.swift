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
import SDWebImage
import UIActivityIndicator_for_SDWebImage
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
    }
    
    func getData(){
        
        //Generates Elements for Timeline
        print("data called")
        //Get Ref of the selected Event.
        let imagesRef = FIRDatabase.database().reference().child("events/" + self.eventID).queryOrderedByChild("date")
        imagesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            //Get Data and append urls to "imagenes"
            if(snapshot.childrenCount > 0){
                self.images.removeAll()
                for view in self.scrollView.subviews {
                    view.removeFromSuperview()
                }
                
                let data = snapshot.value as! Dictionary<String, AnyObject>
                
                for photo in data{
                    
                    
                    
                    let elementinDB = photo.1 as! NSDictionary
                    
                    
                    //Check type of Data.
                    let type = elementinDB["type"] as! String
                    let content = elementinDB["content"] as! String
                    let date = elementinDB["date"] as! NSNumber
                    let user = elementinDB["userdisplay"] as! String
                    //let userid = elementinDB["userid"] as! String
                    
                    if(type == "text"){
                        
                        let element = TimeFrame(text: content, date: "by \(user)", image: nil)
                        self.images.append(element)
                        
                    } else {
                        
                        let element = TimeFrame(text: String(date), date: "by \(user)", image: content)
                        self.images.append(element)
                        
                    }
                    
                    
                    
                    
                }
                self.timeline = TimelineView(bulletType: .Circle, timeFrames: self.images)
                
                //Add Scroll and Constraints
                self.scrollView.addSubview(self.timeline)
                self.scrollView.addConstraints([
                    NSLayoutConstraint(item: self.timeline, attribute: .Left, relatedBy: .Equal, toItem: self.scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: self.timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: self.timeline, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: 40 ),
                    NSLayoutConstraint(item: self.timeline, attribute: .Right, relatedBy: .Equal, toItem: self.scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: self.timeline, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
                    ])
                
                
            } else {
                
                // No Images, show Alert and go Back
                let alertController = UIAlertController(title: "No Images", message:
                    "No images yet, be the first!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                    
                    //Need Mehul to implement Segue to go back.
                    //self.performSegueWithIdentifier("goToEvent", sender: self)
                    
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
            imagesRef.removeAllObservers()
            
        })
    
    }
    
    
    //Action
    @IBAction func sendMessage(sender: AnyObject) {
        
        if(self.textField.text != nil) {
            let storageImagesURL = FIRDatabase.database().reference().child("events/" + self.eventID)
            let message:String = self.textField.text!
            
            var uid = ""
            var displaynameuser = ""
            if let user = FIRAuth.auth()?.currentUser {
                uid = user.uid;
                displaynameuser = user.email!

            }
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddhhmmss"
            let dateString = dateFormatter.stringFromDate(date)
            var dateFinal:NSNumber = 0
            if let number = Int(dateString) {
                dateFinal = NSNumber(integer:number)
            }
            let dataFinal = [
                "date"      : dateFinal,
                "type"      : "text",
                "content"   : message,
                "userid"      : uid,
                "userdisplay": displaynameuser

            ]
            storageImagesURL.childByAutoId().setValue(dataFinal)
            self.textField.text = ""
            
            //Clean and Call Firebase
            getData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
