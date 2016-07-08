//
//  DetalleTableViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/5/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import SDWebImage
import Spring

class DetailTableViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var NavigationBarView: SpringView!
    @IBOutlet weak var EventInfoView: SpringView!
    @IBOutlet weak var MainImageView: SpringImageView!
    @IBOutlet weak var AddPhotoButton: SpringButton!
    @IBOutlet weak var SeeAllPhotosButton: SpringButton!
    @IBOutlet weak var NameOfEventTop: UILabel!
    @IBOutlet weak var LabelCity: UILabel!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelState: UILabel!
    
    //Vars
    var EventImageUrl:String!
    var EventName:String!
    var EventCity:String!
    var EventRegion:String!
    var EventID:String!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidAppear(animated: Bool) {
        //Animate
        
        //Navigation
        NavigationBarView.scaleX = 2.5
        NavigationBarView.scaleY = 2.5
        NavigationBarView.duration = 0.4
        NavigationBarView.curve = "spring"
        NavigationBarView.animateTo()
        NavigationBarView.animateNext{
            self.NavigationBarView.scaleX = 1.0
            self.NavigationBarView.scaleY = 1.0
            self.NavigationBarView.duration = 0.4
            self.NavigationBarView.curve = "spring"
            self.NavigationBarView.animate()
        }
        
        //Event View
        EventInfoView.scaleX = 2.5
        EventInfoView.scaleY = 2.5
        EventInfoView.duration = 0.6
        EventInfoView.curve = "spring"
        EventInfoView.animateTo()
        EventInfoView.animateNext{
            self.EventInfoView.scaleX = 1.0
            self.EventInfoView.scaleY = 1.0
            self.EventInfoView.duration = 0.6
            self.EventInfoView.curve = "spring"
            self.EventInfoView.animate()
        }
        
        //Main ImageView
        MainImageView.scaleX = 0.5
        MainImageView.scaleY = 0.5
        MainImageView.duration = 1.5
        MainImageView.curve = "spring"
        MainImageView.animateTo()
        MainImageView.animateNext{
            self.MainImageView.scaleX = 1.0
            self.MainImageView.scaleY = 1.0
            self.MainImageView.duration = 1.0
            self.MainImageView.curve = "spring"
            self.MainImageView.animate()
        }
        
        //Button 1
        AddPhotoButton.scaleX = 3.0
        AddPhotoButton.scaleY = 3.0
        AddPhotoButton.duration = 1
        AddPhotoButton.curve = "squeezeDown"
        AddPhotoButton.animateTo()
        AddPhotoButton.animateNext{
            self.AddPhotoButton.scaleX = 1.0
            self.AddPhotoButton.scaleY = 1.0
            self.AddPhotoButton.duration = 1.0
            self.AddPhotoButton.curve = "pop"
            self.AddPhotoButton.animate()
        }
        
        //Button 1
        SeeAllPhotosButton.scaleX = 3.0
        SeeAllPhotosButton.scaleY = 3.0
        SeeAllPhotosButton.duration = 1
        SeeAllPhotosButton.curve = "squeezeDown"
        SeeAllPhotosButton.animateTo()
        SeeAllPhotosButton.animateNext{
            self.SeeAllPhotosButton.scaleX = 1.0
            self.SeeAllPhotosButton.scaleY = 1.0
            self.SeeAllPhotosButton.duration = 1.0
            self.SeeAllPhotosButton.curve = "pop"
            self.SeeAllPhotosButton.animate()
        }
    }

    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Declarations
        NameOfEventTop.text = EventName
        LabelName.text = EventName
        LabelCity.text = EventCity
        LabelState.text = EventRegion
        MainImageView.contentMode = .ScaleAspectFit
        
        //Show Main Image
        if let url  = NSURL(string:EventImageUrl) {
            
            let img = UIImage(named: "freebo_logo.png")
            MainImageView.sd_setImageWithURL(url, placeholderImage: img) {
                (img, err, cacheType, imgUrl) -> Void in
            }
            MainImageView.clipsToBounds = true
            
        }//Closes if
        
    }//Closes View Did Load
    
    
    // MARK: Prepare for Segue
    
    //Prepare for Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        //First Segue is for the Photo Options.
        if segue.identifier == "addPhotosSegue" {
                let buttonsViewController = segue.destinationViewController as! ButtonsPhotosViewController
                
                //Send id to View Controller to save in metadata
                buttonsViewController.eventID = EventID
                
        }//Closes If
        
        
        //Second Segue is for the Stream Options.
        if segue.identifier == "showStreamSegue" {
            let streamCollection = segue.destinationViewController as! TimeLineViewController
            
            //Send id to View Controller to save in metadata
            streamCollection.eventID = EventID
            
        }//Closes If
        
    }//Closes prepareForSegue
    
    
}//Closes Class
