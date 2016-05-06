//
//  TakePhotoViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/5/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import Firebase

class TakePhotoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Var Images
    let images          =   Firebase(url:  "https://wilsonapp.firebaseio.com");
    var base64String:       NSString!
    var myImage : UIImage!
    
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
        
        
        let imageData = UIImageJPEGRepresentation(ImagePicked.image!, 0.8)
        //let compressedJPGImage = UIImage(data: imageData!)
        self.base64String = imageData?.base64EncodedStringWithOptions([])
        let quoteString = ["string": self.base64String]
        let userRef = images.childByAppendingPath("images")
        let users = ["image": quoteString]
        userRef.setValue(users, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                
                let alert = UIAlertView(title: "Error",
                    message: "We Could not Add your image to the Steam, please try later.",
                    delegate: nil,
                    cancelButtonTitle: "OK")
                alert.show()
                
            } else {
                
                
                let alert = UIAlertView(title: "Image on Stream!",
                    message: "Your image is on the stream!",
                    delegate: nil,
                    cancelButtonTitle: "OK")
                alert.show()
                
            }
        })

        
        //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if ImagePicked != nil {
            
            ImagePicked.image = myImage
            ImagePicked.contentMode = .ScaleAspectFit
            ButtonUsePhoto.hidden = false
       
        } else {
        
            ButtonUsePhoto.hidden = true
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
