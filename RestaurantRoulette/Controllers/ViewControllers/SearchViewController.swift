//
//  SearchViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var pricePickerView: UIPickerView!
    @IBOutlet weak var radiusPickerView: UIPickerView!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    var prices = ["$", "$$", "$$$", "$$$$", "$$$$$"]
    var radiusLimit = Array(0...24)
    let locationManager = LocationManager.shared
    
    var searchTerm: String?
    var price: String?
    var locationRadius: Int?
    var currentLocation: Bool?
    var currentLatitude: Double?
    var currentLongitude: Double?
    var locationDescription: String?
    var openNow: Bool?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Actions
    @IBAction func currentLocationSwitchDidToggle(_ sender: UISwitch) {
        if sender.isOn {
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if status != .authorizedWhenInUse && status != .authorizedAlways {
                presentLocationAlert(title: "Your location services are disabled for this application.", message: "Please go to settings and enable location services to better locate restaurants!")
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func openNowSwitchDidToggle(_ sender: UISwitch) {
        openNow = sender.isOn ? true : false
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if ((currentLongitude == nil || currentLatitude == nil) && locationDescription == nil) {
            presentLocationAlert(title: "We can't find any restaurants around you!", message: "Please go to settings and enable locations services or enter a location.")
        } else {
            resetLocalProperties()
        }
    }
    
    @IBAction func unwindToSearchFromList(unwindSegue: UIStoryboardSegue) {
        perform(#selector(pushToFavoritesVC), with: nil, afterDelay: 0.0)
    }
    
    @IBAction func unwindToSearchFromMapToBookmarks(unwindSegue: UIStoryboardSegue) {
        perform(#selector(pushToFavoritesVC), with: nil, afterDelay: 0.0)
    }
    
    // MARK: - Methods
    func setupViews() {
        setupTextFields()
        setupPickerViews()
        setupSearchButton()
        // TODO: - Add code that sets the switches to the correct setting.
    }
    
    func setupTextFields() {
        searchTermTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        searchTermTextField.layer.borderWidth = 0.5
        searchTermTextField.layer.cornerRadius = 8
        
        locationTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        locationTextField.layer.borderWidth = 0.5
        locationTextField.layer.cornerRadius = 8
    }
    
    func setupSearchButton() {
        searchButton.layer.cornerRadius = 8
    }
    
    @objc func pushToFavoritesVC() {
        self.performSegue(withIdentifier: "toFavoritesView", sender: self)
    }
    
    func presentLocationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
            if !CLLocationManager.locationServicesEnabled() {
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(enableAction)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetLocalProperties() {
        searchTerm = nil
        price = nil
        locationRadius = nil
        currentLocation = nil
        currentLongitude = nil
        currentLatitude = nil
        locationDescription = nil
        openNow = nil
        searchTermTextField.text = ""
        locationTextField.text = ""
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toRestaurantList" {
            if ((currentLongitude == nil || currentLatitude == nil) && locationDescription == nil) {
                return false
            }
            return true
        } else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantList" {
            guard let destinationVC = segue.destination as? RestaurantsListViewController else { return }
            
            destinationVC.searchTerm = searchTerm
            destinationVC.price = price
            destinationVC.locationRadius = locationRadius
            destinationVC.locationDescription = locationDescription
            destinationVC.currentLongitude = currentLongitude
            destinationVC.currentLatitude = currentLatitude
            destinationVC.openNow = openNow
        }
    }
    
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func setupPickerViews() {
        pricePickerView.delegate = self
        pricePickerView.dataSource = self
        pricePickerView.tintColor = UIColor(red: 115/255.0, green: 113/255.0, blue: 115/255.0, alpha: 100)
        radiusPickerView.delegate = self
        radiusPickerView.dataSource = self
        radiusPickerView.tintColor = UIColor(red: 115/255.0, green: 113/255.0, blue: 115/255.0, alpha: 100)
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return prices[row]
        } else if pickerView.tag == 1 {
            var radiusAsString = String(radiusLimit[row])
            radiusAsString.append(" mi")
            return radiusAsString
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            price = prices[pickerView.selectedRow(inComponent: 0)]
        } else if pickerView.tag == 1 {
            let miles = radiusLimit[pickerView.selectedRow(inComponent: 0)]
            locationRadius = MetersUnitConverter.convertMilesToMetersAsInt(from: Double(miles))
        }
    }
    
    // MARK: - UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return prices.count
        } else if pickerView.tag == 1 {
            return radiusLimit.count
        }
        return 0
    }
    
}
