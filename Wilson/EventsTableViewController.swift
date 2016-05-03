//
//  EventsTableViewController.swift
//  Wilson
//
//  Created by Wilson Muñoz on 5/2/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    //http://api.eventful.com/json/events/search?location=Cancun&app_key=tMPDGBjnXGVq87jZ
    
    let eventsURL = "http://api.eventful.com/json/events/search?location=Cancun&app_key=tMPDGBjnXGVq87jZ"
    var events = [Event]()


    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestLoans()

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

        //cell.amountLabel.text = "$\(loans[indexPath.row].amount)"
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
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data,
                                                                        options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            // Parse JSON data
            let jsonEvents = jsonResult?["events"]!["event"] as! [AnyObject]
            //var jsonEvents = jsonEventsOutside["event"] as [AnyObject]
            for jsonEvent in jsonEvents {
                let event = Event()
                event.name = jsonEvent["title"] as! String
                event.url = jsonEvent["url"] as! String
                //if there is no image need to add placeholder
                //let image = jsonEvent["image"] as! [String:AnyObject]
                //event.image = image["medium"] as! String
                event.address = jsonEvent["olson_path"] as! String
                events.append(event)
            }
        } catch {
            print(error)
        }
        return events
    }


}
