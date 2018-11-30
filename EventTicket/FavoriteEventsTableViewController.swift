//
//  FavoriteEventsTableViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class FavoriteEventsTableViewController: BaseEventsTableViewController {

    @IBOutlet var noFavoritesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.tableView.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInsetAdjustmentBehavior = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateEvents()
        self.tableView.reloadData()
    }
    
    func updateEvents() {
        let nvc = navigationController as! RootNavigationController
        self.events = nvc.favoriteEventList!.events
        if self.events.count == 0 {
            tableView.backgroundView = noFavoritesView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.eventNameLabel.text = self.events[indexPath.row].name
        cell.venueNameLabel.text = self.events[indexPath.row].venueName
        cell.dateTimeLabel.text = self.events[indexPath.row].date + " " + self.events[indexPath.row].time
        cell.thumbnailView.image = self.thumbnail(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = events[indexPath.row]
            let nc = navigationController as! RootNavigationController
            nc.removeFavorite(event: event)
            updateEvents()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
