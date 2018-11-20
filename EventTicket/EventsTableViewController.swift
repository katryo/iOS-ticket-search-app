//
//  EventsTableViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/16.
//  Copyright © 2018 Denkinovel. All rights reserved.
//


import UIKit

class EventsTableViewController: UITableViewController {
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        self.events = [Event(name: "abc", address: "Los Angeles, CA 90007, USA"), Event(name: "Super event", address: "San Francisco, CA 10002, USA")]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell

        cell.eventNameLabel.text = self.events[indexPath.row].name
        cell.venueNameLabel.text = self.events[indexPath.row].venueName
        cell.dateTimeLabel.text = self.events[indexPath.row].date + " " + self.events[indexPath.row].time
        
        var thumbnail = UIImage(named: "sports")!
        switch self.events[indexPath.row].segment {
        case "Sports":
            thumbnail = UIImage(named: "sports")!
        case "Music":
            thumbnail = UIImage(named: "music")!
        case "Arts & Theatre":
            thumbnail = UIImage(named: "arts")!
        case "Film":
            thumbnail = UIImage(named: "film")!
        case "Miscellaneous":
            thumbnail = UIImage(named: "miscellaneous")!
        default:
            print("Segment \(self.events[indexPath.row].segment) not specified and I cannot see the thumbnail")
        }
        cell.thumbnailView.image = thumbnail
        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
