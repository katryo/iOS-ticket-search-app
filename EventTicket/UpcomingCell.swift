//
//  UpcomingCell.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/25.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class UpcomingCell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var typeLabel: UILabel!
    
    var url: URL?
    override func awakeFromNib() {
        //nameButton.titleLabel?.numberOfLines = 1
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func nameButtonClicked(_ sender: UIButton) {
        if let myUrl = url {
            if myUrl != URL(string: "N/A") {
                UIApplication.shared.open(myUrl)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
