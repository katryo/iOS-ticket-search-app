//
//  EventsTableViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/16.
//  Copyright © 2018 Denkinovel. All rights reserved.
//


import UIKit

class EventsTableViewController: BaseEventsTableViewController {
    
    
    @IBOutlet var noResultsLabel: UILabel!
    //    var events: [Event] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if events.count == 0 {
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if events.count == 0 {
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
//
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.events.count
//    }
//
//    override func tableView(_ tableView: UITableView,
//                            didSelectRowAt indexPath: IndexPath) {
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailTBC") as! DetailTBController
//        vc.event = self.events[indexPath.row]
//        self.navigationController!.pushViewController(vc, animated: true)
//
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
//
//        cell.eventNameLabel.text = self.events[indexPath.row].name
//        cell.venueNameLabel.text = self.events[indexPath.row].venueName
//        cell.dateTimeLabel.text = self.events[indexPath.row].date + " " + self.events[indexPath.row].time
//
//        var thumbnail = UIImage(named: "sports")!
//        switch self.events[indexPath.row].segment {
//        case "Sports":
//            thumbnail = UIImage(named: "sports")!
//        case "Music":
//            thumbnail = UIImage(named: "music")!
//        case "Arts & Theatre":
//            thumbnail = UIImage(named: "arts")!
//        case "Film":
//            thumbnail = UIImage(named: "film")!
//        case "Miscellaneous":
//            thumbnail = UIImage(named: "miscellaneous")!
//        default:
//            print("Segment \(self.events[indexPath.row].segment) not specified and I cannot see the thumbnail")
//        }
//        cell.thumbnailView.image = thumbnail
//        // Configure the cell...
//
//        return cell
//    }

}
