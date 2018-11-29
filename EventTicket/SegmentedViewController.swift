//
//  SegmentedViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    lazy var searchVC = storyboard!.instantiateViewController(withIdentifier: "SearchView") as! SearchViewController
    lazy var favoriteVC = storyboard!.instantiateViewController(withIdentifier: "FavoriteEventsViewController") as! FavoriteEventsTableViewController
    
    var currentVC: UIViewController?
    
    //var views: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Places"
        currentVC = searchVC
        showCurrentView(0)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SearchView") as! SearchViewController
//        self.addChild(vc)
        // Do any additional setup after loading the view.
//    viewContainer!.addSubview(vc.view)
//        viewContainer!.bringSubviewToFront(vc.view)
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.currentVC!.view.removeFromSuperview()
        self.currentVC!.removeFromParent()
        showCurrentView(sender.selectedSegmentIndex)
    }
    
    func viewController(with index: Int) -> UIViewController? {
        if index == 0 {
            return searchVC
        } else {
            return favoriteVC
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentVC = currentVC {
            currentVC.viewWillDisappear(animated)
        }
    }
    
    func showCurrentView(_ idx: Int){
        if let vc = viewController(with: idx) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
//            vc.view.frame = self.contentView.bounds
            self.viewContainer.addSubview(vc.view)
            self.currentVC = vc
            //self.currentVC!.viewWillAppear(false)
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
