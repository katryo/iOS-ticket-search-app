//
//  VenueViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/24.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController {
    var venue: Venue?

    @IBOutlet weak var openHourLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = self.tabBarController as! DetailTBController

        WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/venue",
                        queryName: "id",
                        queryValue: tbc.event!.id,
                        success: decodeVenue)

        // Do any additional setup after loading the view.
    }
    
    private func decodeVenue(data: Data) {
        let decoder = JSONDecoder()
        do {
            self.venue = try decoder.decode(Venue.self, from: data)
            self.updateText()
        } catch {
            print("Failed to decode the JSON", error)
            // TODO: Error handling
            return
        }
    }
    
    private func updateText() {
        DispatchQueue.main.async {
            self.openHourLabel.text = self.venue?.openHours
            self.view.layoutIfNeeded()
        }
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
