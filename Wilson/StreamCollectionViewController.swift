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

private let reuseIdentifier = "Cell"

class StreamCollectionViewController: UICollectionViewController {
    //VARS
    var imagenes: [AnyObject] = []
    var eventID: String!
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Ref of the selected Event.
        let imagesRef = FIRDatabase.database().reference().child("events/" + self.eventID)
        imagesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            //let postDict = snapshot.value as! [String : AnyObject]
            
            //Get Data and append urls to "imagenes"
            let data = snapshot.value as! Dictionary<String, String>
            for foto in data{
                self.imagenes.append(foto.1)
            }
            self.collectionView?.reloadData()

            
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
        for image in imagenes{
            //Show Main Image
            if let url  = NSURL(string:image as! String) {
                
                let img = UIImage(named: "photoalbum.png")
                cell.ImageStream.sd_setImageWithURL(url, placeholderImage: img) {
                    (img, err, cacheType, imgUrl) -> Void in
                }
                cell.ImageStream.clipsToBounds = true
                
            }//Closes if
            
        }
        return cell
    }
}
