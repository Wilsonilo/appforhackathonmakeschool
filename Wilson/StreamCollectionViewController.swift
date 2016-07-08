//
//  StreamCollectionViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/6/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Spring
import SwiftSpinner
import SDWebImage


private let reuseIdentifier = "Cell"

class StreamCollectionViewController: UICollectionViewController {
    //VARS
    var images: [AnyObject] = []
    var eventID: String!
    var zoomedImage: Bool = false
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Get Ref of the selected Event.
        let imagesRef = FIRDatabase.database().reference().child("events/" + self.eventID)
        imagesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            //Get Data and append urls to "imagenes"
            if(snapshot.childrenCount > 0){
                let data = snapshot.value as! Dictionary<String, String>
                for photo in data{
                    self.images.append(photo.1)
                }
                self.collectionView?.reloadData()
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

            
        })
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cellIdentifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath:indexPath) as! StreamCollectionViewCell
        
        //Hide Spinner
        SwiftSpinner.hide()
    
        //Animate Images
        cell.ImageStream.clipsToBounds = true
        cell.ImageStream.scaleX = 2.0
        cell.ImageStream.scaleY = 2.0
        cell.ImageStream.duration = 0.8
        cell.ImageStream.curve = "easeOut"
        cell.ImageStream.animateTo()
        
            //Loop Images
            if let url  = NSURL(string:images[indexPath.row] as! String) {
                
                //Set images from URL, also get placeholder
                let img = UIImage(named: "photoalbum.png")
                cell.ImageStream.sd_setImageWithURL(url, placeholderImage: img) {
                    (img, err, cacheType, imgUrl) -> Void in
                    
                    //Animate
                    cell.ImageStream.clipsToBounds = true
                    cell.ImageStream.scaleX = 1.0
                    cell.ImageStream.scaleY = 1.0
                    cell.ImageStream.duration = 2.5
                    cell.ImageStream.curve = "easeIn"
                    cell.ImageStream.animateTo()
                }

        }
        return cell
    }
    
    //View will Appear
    override func viewWillAppear(animated: Bool) {
        //Prepare Spinner
        SwiftSpinner.show("Loading Stream... 1 sec please :)")
    }
    
    
    //willDisplayCell
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //Get cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        //Bring to Front
        cell?.superview?.bringSubviewToFront(cell!)
        
        //Acoomodate
        cell?.contentMode = .Redraw
        cell?.layer.opacity = 0.0
        
        //Animate
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: ({
            
            cell?.layer.opacity = 1.0
            
        }), completion: nil)

    }//willDisplayCell
    
    
    //Did Select
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //If there is a Zoomed Image we reload
        if (self.zoomedImage) {
            
            let indexPathFinal = collectionView.indexPathsForSelectedItems() as [NSIndexPath]!

            collectionView.reloadItemsAtIndexPaths(indexPathFinal)
            zoomedImage = false
        
        //If there is no image Reloaded we zoom in the selected Image
        } else {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.superview?.bringSubviewToFront(cell!)
            cell?.contentMode = .Redraw
            
            UIView.animateWithDuration(1.2, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: ({
                
                cell!.frame = collectionView.bounds
                self.zoomedImage = true

            }), completion: nil)
            
        }// Else
    }//didSelectItemAtIndexPath
    
    
}//Class
