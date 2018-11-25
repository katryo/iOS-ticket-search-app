//
//  Venue.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/19.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import Foundation

class Venue: Codable {
    let name: String
    let address: String
    let city: String
    let phone: String
    let openHours: String
    let generalRule: String
    let childRule: String
}
