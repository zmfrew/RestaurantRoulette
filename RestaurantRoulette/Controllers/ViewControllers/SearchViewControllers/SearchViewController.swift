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
    @IBOutlet weak var querySearchButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    // MARK: - Properties
    var prices = ["$", "$$", "$$$", "$$$$", "$$$$$"]
    var radiusLimit = Array(0...24)
    let locationManager = LocationManager.shared
    
    var searchTerm: String?
    var price: String?
    var locationRadius: Int?
    var currentLocation: Bool {
        return currentLocationSwitch.isOn ? true : false
    }
    var currentLatitude: Double?
    var currentLongitude: Double?
    var locationDescription: String?
    var openNow: Bool?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkLocationAndUpdate()
        // Fetch favorites here to allow for comparing in the RestaurantsList & update the star color if the restaurant is already a favorite.
        RestaurantController.shared.fetchAllRestaurants()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetLocalProperties()
        viewDidLayoutSubviews()
        reloadInputViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Actions
    @IBAction func currentLocationSwitchDidToggle(_ sender: UISwitch) {
        if currentLocation {
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        } else {
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if status != .authorizedWhenInUse && status != .authorizedAlways {
                presentLocationAlert(title: "Your location services are disabled for this application.", message: "Please go to settings and enable location services to better locate restaurants!", enableSettingsLink: true)
            }
            locationManager.stopUpdatingLocation()
            currentLatitude = nil
            currentLongitude = nil
        }
    }
    
    @IBAction func openNowSwitchDidToggle(_ sender: UISwitch) {
        openNow = sender.isOn ? true : false
    }
    
    @IBAction func querySearchButtonTapped(_ sender: UIButton) {
        let status = CLLocationManager.authorizationStatus()
        if ((currentLatitude == nil || currentLongitude == nil) && locationDescription == nil) {
            if status != .authorizedWhenInUse && status != .authorizedAlways {
                presentLocationAlert(title: "We can't find any restaurants around you!", message: "Please go to settings and enable locations services or enter a location.", enableSettingsLink: true)
            } else if status == .denied {
                presentLocationAlert(title: "We can't find any restaurants around you!", message: "Please enter a location.", enableSettingsLink: false)
            } else {
                presentLocationAlert(title: "We can't find any restaurants around you!", message: "Please try again.", enableSettingsLink: false)
            }
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
        setupLocationManager()
        setupTextField()
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
        querySearchButton.layer.cornerRadius = 8
    }
    
    func checkLocationAndUpdate() {
        let status = CLLocationManager.authorizationStatus()
        if currentLocation && (status == .authorizedWhenInUse || status == .authorizedAlways) {
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            currentLatitude = locationManager.location?.coordinate.latitude
            currentLongitude = locationManager.location?.coordinate.longitude
        } else {
            currentLatitude = nil
            currentLongitude = nil
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if locationTextField.isEditing {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func pushToFavoritesVC() {
        self.performSegue(withIdentifier: "toFavoritesView", sender: self)
    }
    
    func presentLocationAlert(title: String, message: String, enableSettingsLink: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if enableSettingsLink {
            let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
                if !CLLocationManager.locationServicesEnabled() {
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
            alert.addAction(enableAction)
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetLocalProperties() {
        searchTerm = nil
        price = nil
        locationRadius = nil
        locationDescription = nil
        openNow = nil
        searchTermTextField.text = ""
        searchTermTextField.placeholder = "Search for food by keyword"
        locationTextField.text = ""
        locationTextField.placeholder = "Enter your location"
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toRestaurantList" {
            if ((currentLatitude == nil || currentLongitude == nil) && locationDescription == nil) {
                return false
            }
            return true
        } else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantList" {
            guard let navigationVC = segue.destination as? UINavigationController,
                let destinationVC = navigationVC.viewControllers.first as? RestaurantsListViewController
                else { print("THIS FAILED");return }

            
            destinationVC.searchTerm = searchTerm
            destinationVC.price = price
            destinationVC.locationRadius = locationRadius
            destinationVC.locationDescription = locationDescription
            destinationVC.currentLatitude = currentLatitude
            destinationVC.currentLongitude = currentLongitude
            destinationVC.openNow = openNow
        }
    }
    
}

// MARK: - CLLocationManagerDelegate Conformance
extension SearchViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error.localizedDescription).")
    }
    
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func setupTextField() {
        searchTermTextField.delegate = self
        locationTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTermTextField {
            guard let searchTerm = searchTermTextField.text, !searchTerm.isEmpty else { return }
            self.searchTerm = searchTerm
        } else if textField == locationTextField {
            guard let locationDescription = locationTextField.text, !locationDescription.isEmpty else { return }
            self.locationDescription = locationDescription
        }
        searchTermTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTermTextField {
            searchTermTextField.resignFirstResponder()
        } else {
            locationTextField.resignFirstResponder()
        }
        return true
    }
    
}


// MARK: - UIPickerViewDelegate & UIPickerViewDataSource Conformance
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
