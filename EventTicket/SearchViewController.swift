//
//  ViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/15.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let units = ["miles" ,"kms"]
    let categories = ["Music", "Sports"]
    let categoryPicker = UIPickerView()
    @IBOutlet weak var keywordField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryField.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        unitPicker.delegate = self
        unitPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return self.categories.count
        } else {
            return self.units.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else {
            return units[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryField.text = categories[row]
        } else {
            print("On no")
        }
    }

    @IBAction func searchButtonPushed(_ sender: UIButton) {
        print(self.keywordField.text!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsTableView") as! EventsTableViewController
        
        var events: [Event] = []
        let url = URL(string: "https://ios-event-ticket-usc.appspot.com/api/events?lat=34.0266&lng=-118.2831")

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                // TODO: Error handling
                print("Error: \(error!.localizedDescription) \n")
                SwiftSpinner.hide()
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or no response")
                SwiftSpinner.hide()
                // TODO: Error handling
                return
            }
            
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let eventList: EventList = try decoder.decode(EventList.self, from: data)
                    events = eventList.events
                    vc.events = events
                    DispatchQueue.main.async {
                        vc.tableView.reloadData()
                        SwiftSpinner.hide()
                    }
                } catch {
                    print("Failed to decode the JSON", error.localizedDescription)
                    // TODO: Error handling
                    SwiftSpinner.hide()
                }
            } else {
                // TODO: Error handling
                print("Status code: \(response.statusCode)\n")
                SwiftSpinner.hide()
            }
        }
        
        SwiftSpinner.show("Searching for events...")
        task.resume()
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
}

