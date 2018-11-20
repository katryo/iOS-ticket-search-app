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
        
        let url = URL(string: "https://ios-event-ticket-usc.appspot.com/api/events?lat=34.0266&lng=-118.2831")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("Error: \(error!.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or no response")
                return
            }
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                print("here")
                do {
                    let eventList: EventList = try decoder.decode(EventList.self, from: data)
                    self.events = eventList.events
                    print(self.events.count)
                    
                    self.tableView.reloadData()
                } catch {
                    print("Failed to decode the JSON", error.localizedDescription)
                }
            } else {
                print("Status code: \(response.statusCode)\n")
            }
        }
        task.resume()
        
        
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
    
        cell.thumbnailView.image = UIImage(named: "location")
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
