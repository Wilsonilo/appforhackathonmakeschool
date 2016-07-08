////
////  TakePhotoViewController.swift
////  Wilson
////
////  Created by Wilson Muñoz on 5/5/16.
////  Copyright © 2016 Wilson Muñoz. All rights reserved.
////

import UIKit
import Firebase
import SwiftSpinner

class TakePhotoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //VARS
    let storageImages = FIRStorage.storage().referenceForURL("gs://hackathonappmakescho.appspot.com/images/")
    var myImage: UIImage!
    var eventID: String!
    
    //Outlets
    @IBOutlet weak var ButtonUsePhoto: UIButton!
    @IBOutlet weak var ImagePicked: UIImageView!
    
    //Click on Image to use camera
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Did Finish Picking Image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        ImagePicked.image = image
        ButtonUsePhoto.hidden = false
        ButtonUsePhoto.layer.opacity = 0.85
        ImagePicked.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //User uses image
    @IBAction func SendPhotoToStream(sender: AnyObject) {
        
        //Run Spinner
        SwiftSpinner.show("Sending Image to Stream Baby!...")
        
        //Set Image
        let imageData = UIImageJPEGRepresentation(ImagePicked.image!, 0.8)
        
        
        // Save image inside an independent Folder with a certain ID
        let imagesRef = storageImages.child(self.eventID)
        
        
        
        
        let imageRef = imagesRef.child("\(NSUUID().UUIDString).jpg")
        
        
        //Add Metadata to Image
        //We could add user to metadata, date, etc.
        let metadata = FIRStorageMetadata()
        metadata.customMetadata = [
            "eventID": eventID
        ]
        
        // Upload the file to the path "images"
        imageRef.putData(imageData!, metadata: metadata) { metadata, error in
            
            //Hide Spinner no matter what
            SwiftSpinner.hide()
            
            if (error != nil) {
                
                // Uh-oh, an error occurred!
                let alertController = UIAlertController(title: "Error", message:
                    "We got and error :( Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                    
                    self.performSegueWithIdentifier("goToStream", sender: self)
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                // Metadata contains file metadata such as size, content-type, and download URL.
                //let metadata = metadata
                
                //Get URL to Add to DB
                let downloadURL = metadata!.downloadURL
                let storageImagesURL = FIRDatabase.database().reference().child("events/" + self.eventID)
                
                //save URL of image inside the events/EVENTID Folder for future Fetching
                let downloadURLFinal:String = (downloadURL()?.absoluteString)!
                storageImagesURL.childByAutoId().setValue(downloadURLFinal)
                
                
                //Show Alert of Success
                let alertController = UIAlertController(title: "Success!", message:
                    "Image on Stream!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                    self.performSegueWithIdentifier("goToStream", sender: self)
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }//Else
        }//imageRef.putData
        

    }//IBAction Finishes
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if ImagePicked != nil {
            
            ImagePicked.image = myImage
            ImagePicked.contentMode = .ScaleAspectFit
            ButtonUsePhoto.hidden = false
       
        } else {
        
            ButtonUsePhoto.hidden = true
        
        }
    }//View Did load Finishes
    
    //Prepare for Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStream" {
            let streamCollection = segue.destinationViewController as! TimeLineViewController
            
            //Send id to View Controller to save in metadata
            streamCollection.eventID = self.eventID
        }
    }
    
    //Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}//Class finishes
