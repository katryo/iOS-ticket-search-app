//
//  RootNavigationController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    var favoriteEventList: EventList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json: [String: [Event]] = ["events": []]
        let emptyData = try? JSONEncoder().encode(json)
        
        favoriteEventList = try? JSONDecoder().decode(EventList.self, from: emptyData!)

        let data = UserDefaults.standard.data(forKey: "favoriteEvents")
        if data != nil {
            let eventsList = try? JSONDecoder().decode(EventList.self, from: data!)
            if eventsList != nil {
                favoriteEventList = eventsList
            }
        }
    }
}
