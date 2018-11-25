//
//  VenueViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/24.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class VenueViewController: UIViewController {
    var venue: Venue?

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var openHourLabel: UILabel!
    @IBOutlet weak var generalRulesLabel: UILabel!
    @IBOutlet weak var childRulesLabel: UILabel!
    
    @IBOutlet weak var mapUIView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if venue != nil {
            updateText()
        } else {
            let tbc = self.tabBarController as! DetailTBController
            WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/venue",
                            queryName: "id",
                            queryValue: tbc.event!.id,
                            success: decodeVenue)
        }
//
//        

        // Do any additional setup after loading the view.
    }
    
    func decodeVenue(data: Data) {
        let decoder = JSONDecoder()
        do {
            self.venue = try decoder.decode(Venue.self, from: data)
            updateText()
        } catch {
            print("Failed to decode the JSON", error)
            // TODO: Error handling
            return
        }
    }
    
    private func updateText() {
        if self.openHourLabel != nil {
            
            DispatchQueue.main.async {
                self.openHourLabel.text = self.venue?.openHours
            self.addressLabel.text = self.venue?.address
            self.cityLabel.text = self.venue?.city
            self.phoneLabel.text = self.venue?.phone
            self.generalRulesLabel.text = self.venue?.generalRule
            self.childRulesLabel.text = self.venue?.childRule
            
            let camera = GMSCameraPosition.camera(withLatitude: (self.venue?.latitude)!, longitude: (self.venue?.longitude)!, zoom: 10.0)
            self.mapUIView.camera = camera
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (self.venue?.latitude)!, longitude: (self.venue?.longitude)!)
            marker.map = self.mapUIView
            
                self.view.layoutIfNeeded()
            }
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
