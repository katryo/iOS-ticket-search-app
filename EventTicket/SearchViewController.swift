//
//  ViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/15.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner
import CoreLocation
import EasyToast

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let units = ["miles" ,"kms"]
    let categories = ["All", "Music", "Sports", "Arts & Theatre", "Film", "Miscellaneous"]
    var unit = "miles"
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    var isCurrentLocation = true
    var suggestions = ["abc", "edf", "ww", "baasda", "qq"]
//    var suggestions: [String] = []
    
    var suggestionsTableView: UITableView!
    let categoryPicker = UIPickerView()
    var suggestionThrottleQueue = ThrottleQueue()
    
    @IBOutlet weak var keywordField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var customLocationButton: UIButton!
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keywordField.delegate = self

        suggestionsTableView = UITableView(
            frame: CGRect(
                x: self.keywordField.frame.minX,
                y: self.keywordField.frame.maxY,
                width: self.keywordField.frame.width,
                height: 0
            )
        )
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        self.view.addSubview(suggestionsTableView)
        suggestionsTableView.reloadData()
        
        self.categoryField.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let pickerBar = UIToolbar()
        pickerBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClicked))
        
        // Just fill the space
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClicked))
        pickerBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        categoryField.inputAccessoryView = pickerBar
        
        unitPicker.delegate = self
        unitPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        //if #available(iOS 9.0, *) {
        locationManager = CLLocationManager()
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation() // 一度きりの取得
        //}
        
        print(suggestionsTableView.contentSize)
    }
    
    
    
    @IBAction func currentLocationClicked(_ sender: UIButton) {
        isCurrentLocation = true
        self.customLocationButton.setTitle("○", for: .normal)
        self.currentLocationButton.setTitle("●", for: .normal)
    }
    
    @IBAction func customLocationClicked(_ sender: UIButton) {
        isCurrentLocation = false
        
        self.customLocationButton.setTitle("●", for: .normal)
        self.currentLocationButton.setTitle("○", for: .normal)
    }
    
    @objc
    func doneClicked() {
        categoryField.resignFirstResponder()
    }
    
    @objc
    func cancelClicked() {
        categoryField.resignFirstResponder()
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
            self.unit = units[row]
        }
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        suggestionsTableView.frame = CGRect(
//            x: self.keywordField.frame.minX,
//            y: self.keywordField.frame.maxY,
//            width: self.keywordField.frame.width,
//            height: 400
//        )
//        self.view.layoutIfNeeded()
//    }

    @IBAction func searchButtonPushed(_ sender: UIButton) {
        
        if self.keywordField.text == nil || self.keywordField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.view.showToast("Keyword and location are mandatory fields", position: .bottom, popTime: 4, dismissOnTap: false)
            return
        }
        
        let lat: Double
        let lng: Double
        
        if self.isCurrentLocation {
            if self.latitude == nil || self.longitude == nil {
                self.view.showToast("Location not available", position: .bottom, popTime: 4, dismissOnTap: false)
                return
            }
            lat = self.latitude!
            lng = self.longitude!
            search(lat: lat, lng: lng)
        } else {
            if self.locationField.text == nil || self.locationField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                self.view.showToast("Keyword and location are mandatory fields", position: .bottom, popTime: 4, dismissOnTap: false)
                return
            }
            
            fetchLatLng(address: self.locationField.text!)
        }
    }
    
    private func fetchLatLng(address: String) {
        let url = URL(string: "https://ios-event-ticket-usc.appspot.com/api/latlng?address=\(self.locationField.text!)")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                // TODO: Error handling
                print("Error: \(error!.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or no response")
                // TODO: Error handling
                return
            }
            
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                let latLng: LatLng
                do {
                    latLng = try decoder.decode(LatLng.self, from: data)
                } catch {
                    print("Failed to decode the JSON", error)
                    // TODO: Error handling
                    return
                }
                
                DispatchQueue.main.async {
                    self.search(lat: latLng.lat, lng: latLng.lng)
                }
            } else {
                // TODO: Error handling
                print("Status code: \(response.statusCode)\n")
            }
        }
        task.resume()
    }
    
    private func fetchSuggestions(keyword: String) {
        print("fetchSugges")
        let baseUrl = URL(string: "https://ios-event-ticket-usc.appspot.com/api/suggestions")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            if error != nil {
                // TODO: Error handling
                print("Error: \(error!.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or no response")
                // TODO: Error handling
                return
            }
            
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let suggestionList: SuggestionList = try decoder.decode(SuggestionList.self, from: data)
                    self.suggestions = suggestionList.suggestions
                    
                    DispatchQueue.main.async {
                        self.suggestionsTableView.frame = CGRect(
                            x: self.keywordField.frame.minX,
                            y: self.keywordField.frame.maxY,
                            width: self.keywordField.frame.width,
                            height: CGFloat(44 * self.suggestions.count)
                        )
                        self.suggestionsTableView.reloadData()
                    }
                    return
                } catch {
                    print("Failed to decode the JSON", error)
                    // TODO: Error handling
                    return
                }

            } else {
                // TODO: Error handling
                print("Status code: \(response.statusCode)\n")
            }
        }
        task.resume()
    }
    
    
    private func search(lat: Double, lng: Double) {
        print(self.keywordField.text!)
        
        let radius:Int
        if self.distanceField.text != nil && !self.distanceField.text!.isEqual("") {
            radius = Int(self.distanceField.text!)!
        } else {
            radius = 10
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsTableView") as! EventsTableViewController
        
        var events: [Event] = []
        let baseUrl = URL(string: "https://ios-event-ticket-usc.appspot.com/api/events")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng)),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "unit", value: self.unit),
            URLQueryItem(name: "keyword", value: self.keywordField.text!)]
        print(components.url!)

        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
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
                    print("Failed to decode the JSON", error)
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        print("ww")
//        self.suggestionsTableView.frame = 300
//        self.suggestionsTableView.reloadData()
        if let text = textField.text {
            self.suggestionThrottleQueue.throttle {
                self.fetchSuggestions(keyword: text)
            }
            //let textRange = Range(range, in: text) {
            //let updatedText = text.replacingCharacters(in: textRange,
                                      //                 with: string)
            // myvalidator(text: updatedText)
        }
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
        print("The textField ended editing. Do something based on app requirements.")
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("abc", self.suggestions.count)
        return self.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "SuggestionCell")
        print("cell")
        cell.textLabel?.text = self.suggestions[indexPath.row]
        return cell
    }

}

extension SearchViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("latitude:\(location.coordinate.latitude) longitude:\(location.coordinate.longitude) time:\(location.timestamp.description)")
            self.longitude = location.coordinate.longitude
            self.latitude = location.coordinate.latitude
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not yet determined")
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("No location")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("Can not locate the device")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("Location detection is authorized")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("authorized when in use")
            // 位置情報取得の開始処理
            break
        }
    }
}
