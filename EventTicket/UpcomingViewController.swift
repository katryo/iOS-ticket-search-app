//
//  UpcomingViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/25.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner


class UpcomingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var upcomingEvents: [UpcomingEvent]?
    let sortItems = ["default", "name", "time", "artist", "type"]
    var sortBy = 0
    var orderBy = 0

    @IBOutlet weak var orderByControl: UISegmentedControl!
    @IBOutlet var noUpcomingLabel: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        let tbc = self.tabBarController as! DetailTBController
        SwiftSpinner.show("Searching for upcoming events...")
        WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/upcoming",
                        queryName: "query",
                        queryValue: tbc.event!.venueName,
                        not200: fetchEventNot200,
                        failure: failedFetchEvent,
                        success: decodeUpcomingEvents
                        )
        // Do any additional setup after loading the view.
    }
   
    @IBAction func sortByChanged(_ sender: UISegmentedControl) {
        if sortBy == 0 && sender.selectedSegmentIndex != 0 {
            orderByControl.isEnabled = true
        } else if sortBy != 0 && sender.selectedSegmentIndex == 0 {
            orderByControl.isEnabled = false
        }
        sortBy = sender.selectedSegmentIndex
        eventsTableView.reloadData()
    }
    
    @IBAction func orderChanged(_ sender: UISegmentedControl) {
        orderBy = sender.selectedSegmentIndex
        eventsTableView.reloadData()
    }
    
    private func fetchEventNot200(response: HTTPURLResponse) {
        self.updateEventsOrNot()
        let tbc = self.tabBarController as! DetailTBController
        
        DispatchQueue.main.async {
            self.view.showToast("Could not find upcoming events of \(tbc.event!.venueName)", position: .bottom, popTime: 4, dismissOnTap: false)
        }
    }
    
    private func failedFetchEvent(error: Error) {
        self.updateEventsOrNot()

        let tbc = self.tabBarController as! DetailTBController
        
        DispatchQueue.main.async {
            self.view.showToast("Could not find upcoming events of \(tbc.event!.venueName)", position: .bottom, popTime: 4, dismissOnTap: false)
        }
    }
    
    private func updateEventsOrNot() {
        DispatchQueue.main.async {
            if self.upcomingEvents != nil && self.upcomingEvents!.count > 0 {
                self.eventsTableView.backgroundView = nil
                self.eventsTableView.separatorStyle = .singleLine
            } else {
                self.eventsTableView.backgroundView = self.noUpcomingLabel
                self.eventsTableView.separatorStyle = .none
            }
            
            self.eventsTableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    private func decodeUpcomingEvents(data: Data) {
        let decoder = JSONDecoder()
        do {
            let upcomingEventList: UpcomingEventList
            upcomingEventList = try decoder.decode(UpcomingEventList.self, from: data)
            let events = upcomingEventList.upcomingEvents
            if events.count > 5 {
                upcomingEvents = Array(events[0..<5])
            } else {
                upcomingEvents = events
            }
            self.updateEventsOrNot()
            
        } catch {
            print("Failed to decode the JSON", error)
            // TODO: Error handling
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if upcomingEvents != nil {
            return upcomingEvents!.count
        } else {
            return 0
        }
    }
    
    private func sortedEvents() -> [UpcomingEvent] {
        let events = upcomingEvents!
        switch sortBy {
        case 0:
            return events
        case 1:
            if orderBy == 1 {
                return events.sorted(by: { $0.name > $1.name })
            } else {
                return events.sorted(by: { $0.name < $1.name })
            }
        case 2:
            if orderBy == 1 {
                return events.sorted(by: { $0.unixtime > $1.unixtime })
            } else {
                return events.sorted(by: { $0.unixtime < $1.unixtime })
            }
        case 3:
            if orderBy == 1 {
                return events.sorted(by: { $0.artistName > $1.artistName })
            } else {
                return events.sorted(by: { $0.artistName < $1.artistName })
            }
        case 4:
            if orderBy == 1 {
                return events.sorted(by: { $0.type > $1.type })
            } else {
                return events.sorted(by: { $0.type < $1.type })
            }
        default:
            print("Unexpected sort/order.")
            return events
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let upcomingEvent = sortedEvents()[indexPath.row]
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as! UpcomingCell
        
        cell.nameButton.setTitle(upcomingEvent.name, for: .normal)
        cell.timeLabel.text = upcomingEvent.time
        cell.typeLabel.text = "Type: \(upcomingEvent.type)"
        cell.artistLabel.text = upcomingEvent.artistName
        
        cell.url = upcomingEvent.url
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
