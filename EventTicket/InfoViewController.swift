//
//  InfoViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class InfoViewController: BaseDetailController {

    @IBOutlet weak var ticketmasterButton: UIButton!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    
    @IBOutlet weak var ticketStatusLabel: UILabel!

    

    @IBOutlet weak var seatmapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbController = self.tabBarController! as! DetailTBController
        print(tbController.event.name)
        print("yey")
        
        if tbController.event.artistNames.count > 0 {
            artistsLabel.text = tbController.event.artistNames.joined(separator: "|")
        } else {
            artistsLabel.text = "N/A"
        }
        
        venueNameLabel.text = tbController.event.venueName
        
        timeLabel.text = tbController.event.llTime
        
        categoryLabel.text = tbController.event.categoryString
        priceRangeLabel.text = tbController.event.priceRange
        
        ticketStatusLabel.text = tbController.event.ticketStatus
        
        if tbController.event.seatmap == URL(string: "N/A") {
            seatmapButton.titleLabel!.text = "N/A"
        }
        
        if tbController.event.url == URL(string: "N/A") {
            ticketmasterButton.titleLabel!.text = "N/A"
        }
    }
    
    @IBAction func seatmapButtonClicked(_ sender: UIButton) {
        let tbController = self.tabBarController! as! DetailTBController
        if tbController.event.seatmap != URL(string: "N/A") {
            UIApplication.shared.open(tbController.event.seatmap)
        }
        
    }
    
    @IBAction func ticketmasterButtonClicked(_ sender: UIButton) {
        let tbController = self.tabBarController! as! DetailTBController
        if tbController.event.url != URL(string: "N/A") {
            UIApplication.shared.open(tbController.event.url)
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
