//
//  SearchViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var pricePickerView: UIPickerView!
    @IBOutlet weak var radiusPickerView: UIPickerView!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    var price: String?
    var locationRadius: Int?
    var prices = ["$", "$$", "$$$", "$$$$", "$$$$$"]
    var radiusLimit = Array(0...24)
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // TODO: - Insert network request logic
    }
    
    @IBAction func bookmarksButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func unwindToSearch(unwindSegue: UIStoryboardSegue) {
        perform(#selector(pushToFavoritesVC), with: nil, afterDelay: 0.0)
    }
    
    @objc func pushToFavoritesVC() {
//        let favoritesVC = (self.storyboard?.instantiateViewController(withIdentifier: "FavoritesListViewController"))!
        self.performSegue(withIdentifier: "toFavoritesView", sender: self)
    }
    
    // MARK: - Methods
    func setupViews() {
        setupTextFields()
        setupPickerViews()
        setupSearchButton()
        // TODO: - Add code that sets the switches to the correct setting.
    }
    
    func setupTextFields() {
        keywordTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        keywordTextField.layer.borderWidth = 0.5
        keywordTextField.layer.cornerRadius = 8
        
        locationTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        locationTextField.layer.borderWidth = 0.5
        locationTextField.layer.cornerRadius = 8
    }
    
    func setupSearchButton() {
        searchButton.layer.cornerRadius = 8
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
