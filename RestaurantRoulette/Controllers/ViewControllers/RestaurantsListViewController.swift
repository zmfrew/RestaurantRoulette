//
//  RestaurantsListViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class RestaurantsListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindToSearchFromList(unwindSegue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        return RestaurantController.shared.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let restaurant = RestaurantController.shared.restaurants[indexPath.row]
        cell.restaurant = restaurant
        return cell
    }
    
}
