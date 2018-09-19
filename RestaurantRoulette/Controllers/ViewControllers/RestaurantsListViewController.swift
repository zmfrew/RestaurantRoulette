//
//  RestaurantsListViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class RestaurantsListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var randomBusiness: CDYelpBusiness? // TODO: - Convert from CDYelpBusiness to randomRestaurant
    var businesses: [CDYelpBusiness] = []
    var searchTerm: String?
    var price: String?
    var locationRadius: Int?
    var currentLatitude: Double?
    var currentLongitude: Double?
    var locationDescription: String?
    var openNow: Bool?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.main.async {
            self.searchForBusinessesBy(searchTerm: self.searchTerm, location: self.locationDescription, latitude: self.currentLatitude, longitude: self.currentLongitude, locationRadius: self.locationRadius, price: self.price, openNow: self.openNow)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToSearchFromList(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSearchFromMap(unwindSegue: UIStoryboardSegue) {
        perform(#selector(dismissToSearchVC), with: nil, afterDelay: 0.0)
    }
    
    // MARK: - Methods
    func searchForBusinessesBy(searchTerm: String?, location: String?, latitude: Double?, longitude: Double?, locationRadius: Int?, price: String?, openNow: Bool?) {
        let priceTiers = CDYelpFusionKitManager.shared.setPriceTierForSearch(price)
        
        CDYelpFusionKitManager.shared.apiClient.searchBusinesses(byTerm: searchTerm, location: location, latitude: latitude, longitude: longitude, radius: locationRadius, categories: nil, locale: nil, limit: 50, offset: nil, sortBy: CDYelpBusinessSortType.bestMatch, priceTiers: priceTiers, openNow: openNow, openAt: nil, attributes: nil) { (response) in
            if let response = response, let businesses = response.businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                self.selectRandomBusiness()
            } else {
                self.presentSearchError()
            }
        }
    }
    
    func presentSearchError() {
        let alert = UIAlertController(title: "Oh no!", message: "We couldn't find any restaurants. Please try searching again!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController")
            self.present(searchVC, animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissToSearchVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectRandomBusiness() {
        let randomIndex = Int(arc4random_uniform(UInt32(businesses.count)))
        randomBusiness = businesses[randomIndex]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRandomRestaurantMap" {
            guard let destinationVC = segue.destination as? RandomRestaurantMapViewController,
                let randomBusiness = randomBusiness else { return }
            
            destinationVC.navigationController?.navigationBar.prefersLargeTitles = true
            destinationVC.title = randomBusiness.name
            destinationVC.business = randomBusiness
        }
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource Conformance
extension RestaurantsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as? BusinessTableViewCell else { return UITableViewCell() }
        
        let business = businesses[indexPath.row]
        cell.business = business
        return cell
    }
    
}
