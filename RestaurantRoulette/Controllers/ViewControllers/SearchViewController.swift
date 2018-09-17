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
    @IBOutlet weak var locationTextField: UITextField!
    
    
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    
    // MARK: - Methods
    func setupViews() {
        setupTextFields()
        setupSearchButton()
        // TODO: - Add code that sets the switches to the correct setting.
    }
    
    func setupTextFields() {
        keywordTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        keywordTextField.layer.borderWidth = 1
        keywordTextField.layer.cornerRadius = 8
        
        locationTextField.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 100).cgColor
        locationTextField.layer.borderWidth = 1
        locationTextField.layer.cornerRadius = 8
    }
    
    func setupSearchButton() {
        searchButton.layer.cornerRadius = 8
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
