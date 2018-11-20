//
//  EventCell.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/19.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // self.thumbnailView.image = UIImage(named: "calendar")

        // Configure the view for the selected state
    }

}
