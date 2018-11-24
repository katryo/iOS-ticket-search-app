//
//  FavoriteEventsTableViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class FavoriteEventsTableViewController: BaseEventsTableViewController {

    override func viewDidLoad() {
        print("vdlll")
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("vwa")
        let nvc = navigationController as! RootNavigationController
        self.events = nvc.favoriteEventList!.events
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.eventNameLabel.text = self.events[indexPath.row].name
        cell.venueNameLabel.text = self.events[indexPath.row].venueName
        cell.dateTimeLabel.text = self.events[indexPath.row].date + " " + self.events[indexPath.row].time
        cell.thumbnailView.image = self.thumbnail(indexPath: indexPath)
        
        return cell
    }
    
}
