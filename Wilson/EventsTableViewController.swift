//
//  EventsTableViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/2/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SDWebImage

class EventsTableViewController: UITableViewController {
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    //Using Prototype Data
    //For real live data change to (50 calls per day): http://api.eventful.com/json/events/search?location=San+Francisco&app_key=tMPDGBjnXGVq87jZ&radius=50&page=1
    let eventsURL = "http://wilsonmunoz.net/makeschool/prototypedata.json"
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestLoans()
        
        // Shift UITabbar Down
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",
                                                               forIndexPath: indexPath) as! EventTableViewCell
        // Configure the cell...
        cell.titleLabel.text = events[indexPath.row].name
        cell.AddressLabel.text = events[indexPath.row].address
        cell.urlLabel.text = events[indexPath.row].url
        //Declare the url and placeholder
        if let url  = NSURL(string:events[indexPath.row].image) {
            let img = UIImage(named: "freebo_logo.png")
            cell.imageCell.sd_setImageWithURL(url, placeholderImage: img) {
                (img, err, cacheType, imgUrl) -> Void in
            }
            cell.imageCell.clipsToBounds = true
            cell.imageCell.layer.cornerRadius =  cell.imageCell.frame.size.width / 2;
            cell.imageCell.layer.opacity = 1.0
        }
        return cell
    }
    
    
    // MARK: Helpers
    
    func getLatestLoans() {
        let request = NSURLRequest(URL: NSURL(string: eventsURL)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            // Parse JSON data
            if let data = data {
                self.events = self.parseJsonData(data)
                // Reload table view
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [Event] {
        var events = [Event]()
        let json = JSON(data: data)
        // Parse JSON data
        let jsons: JSON = json["events"]["event"]
        for json in jsons.arrayValue {
            let event = Event()
            event.name = json["title"].stringValue
            event.url = json["region_name"].stringValue
            //Check if we have images in this event
            if json["image"] != nil {
                let image = json["image"]
                if (image["medium"] != nil) {
                    event.image = image["medium"]["url"].stringValue
                }
            }

            event.address = json["city_name"].stringValue
            event.id = json["id"].stringValue
            events.append(event)
        }
        return events
    }
    
    // MARK: Prepare for Segue
    //Reescribimos el PrepareforSegue para enviar Información
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "verEvento" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DetailTableViewController
                
                //Send data to Single View
                destinationController.EventName = events[indexPath.row].name
                destinationController.EventCity = events[indexPath.row].address
                destinationController.EventRegion = events[indexPath.row].url
                destinationController.EventImageUrl = events[indexPath.row].image
                destinationController.EventID = events[indexPath.row].id
                
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
