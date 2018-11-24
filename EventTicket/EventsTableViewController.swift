//
//  EventsTableViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/16.
//  Copyright © 2018 Denkinovel. All rights reserved.
//


import UIKit
import EasyToast

protocol EventCellProtocol {
    func toggleFavoriteButton(sender: UIButton)
}

class EventsTableViewController: BaseEventsTableViewController, EventCellProtocol {
    func toggleFavoriteButton(sender: UIButton) {
        let index: Int = sender.tag
        let event = events[index]
        let nc = navigationController as! RootNavigationController
        if nc.hasFavorited(event: event) {
            nc.removeFavorite(event: event)
            self.view.showToast("\(event.name) was removed from favorites", position: .bottom, popTime: 4, dismissOnTap: false)
            sender.setImage(#imageLiteral(resourceName: "favorite-empty"), for: .normal)
        } else {
            nc.addFavorites(event: event)
            self.view.showToast("\(event.name) was added to favorites", position: .bottom, popTime: 4, dismissOnTap: false)
            sender.setImage(#imageLiteral(resourceName: "favorite-filled"), for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! EventCell
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteDelegate = self
        let nc = navigationController as! RootNavigationController
        if nc.hasFavorited(event: events[indexPath.row]) {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favorite-filled"), for: .normal)
        } else {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favorite-empty"), for: .normal)
        }
        return cell
    }

        
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

}