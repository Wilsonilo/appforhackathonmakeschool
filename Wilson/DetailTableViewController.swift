//
//  DetalleTableViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/5/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import SDWebImage

class DetailTableViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var NavigationBarView: UIView!
    @IBOutlet weak var EventInfoView: UIView!
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var AddPhotoButton: UIButton!
    @IBOutlet weak var SeeAllPhotosButton: UIButton!
    @IBOutlet weak var NameOfEventTop: UILabel!
    @IBOutlet weak var LabelCity: UILabel!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelState: UILabel!
    
    //Vars
    var EventImageUrl:String!
    var EventName:String!
    var EventCity:String!
    var EventRegion:String!
    let gradientLayer = CAGradientLayer()

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
            let img = UIImage(named: "photoalbum.png")
            MainImageView.sd_setImageWithURL(url, placeholderImage: img) {
                (img, err, cacheType, imgUrl) -> Void in
            }
            MainImageView.clipsToBounds = true
        }
    }
}
