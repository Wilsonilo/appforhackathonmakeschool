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
    
    var imagenes: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.IMAGES_REF.observeEventType(.Value, withBlock: { snapshot in
            self.imagenes.insert(snapshot.value!, atIndex: 0)
            self.collectionView?.reloadData()
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagenes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cellIdentifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath:indexPath) as! StreamCollectionViewCell
        
        DataService.dataService.IMAGES_REF.observeEventType(.Value, withBlock: { snapshot in
            
            print(self.imagenes.count)
            
            let imageString = self.imagenes[indexPath.row]["image"] as! [String:AnyObject]
            let base64EncodedString = imageString["string"]
            let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let image = UIImage(data: imageData!)
            cell.ImageStream.image = image
        
            }, withCancelBlock: { error in
                
                print(error.description)
        })        
        return cell
    }
}
