//
//  DetailTBController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class DetailTBController: UITabBarController {
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-empty"), style: .plain, target: self, action: #selector(twitterClicked))
        let twitterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "twitter"), style: .plain, target: self, action: #selector(twitterClicked))
        navigationItem.rightBarButtonItems = [button, twitterButton]
        print("vdl")
    }
    
    @objc
    func twitterClicked() {
        var components = URLComponents(string: "https://twitter.com/intent/tweet")
        let text = "Check out \(event.artistNames.joined(separator: " | ")) at \(event.venueName). Website: \(event.url)"
        components!.queryItems = [URLQueryItem(name: "text", value: text)]
        UIApplication.shared.open(components!.url!)
    }
    
    @objc
    func favClicked() {
        
    }
 
}
