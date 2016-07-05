//
//  ButtonsPhotosViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/5/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import Firebase

class ButtonsPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Vars
    var myImage : UIImage!


    @IBAction func SelectPhotoFromLibrary(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //let ImageFromLibrary = UIImageView(image: image)
        self.myImage = image
        if(self.myImage != nil){
            
            //self.dismissViewControllerAnimated(true, completion: nil);
            dismissViewControllerAnimated(true, completion: { () -> Void in
                self.performSegueWithIdentifier("PhotoLibrarySegue", sender: self)
            })
        
        } else {
            print("i get nil on the image")
        }
    }
    
    //Reescribimos el PrepareforSegue para enviar Información
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "PhotoLibrarySegue" {
            let destinationController = segue.destinationViewController as! TakePhotoViewController
                destinationController.myImage = myImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
