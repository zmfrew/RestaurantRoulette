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
    
    // MARK: - Properties
    var randomRestaurant: Restaurant?
    
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
        let randomIndex = Int(arc4random_uniform(UInt32(RestaurantController.shared.restaurants.count)))
        randomRestaurant = RestaurantController.shared.restaurants[randomIndex]
    }
    
    @IBAction func unwindToSearchFromList(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSearchFromMapToBookmarks(unwindSegue: UIStoryboardSegue) {
        perform(#selector(dismissToSearchVC), with: nil, afterDelay: 0.0)
    }
    
    @IBAction func unwindToSearchFromMap(unwindSegue: UIStoryboardSegue) {
        perform(#selector(dismissToSearchVC), with: nil, afterDelay: 0.0)
    }
    
    // MARK: - Methods
    @objc func dismissToSearchVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRandomRestaurantMap" {
            guard let destinationVC = segue.destination as? RandomRestaurantMapViewController,
                let randomRestaurant = randomRestaurant else { return }
            
            destinationVC.title = randomRestaurant.name
            destinationVC.restaurant = randomRestaurant
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
        return RestaurantController.shared.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let restaurant = RestaurantController.shared.restaurants[indexPath.row]
        cell.restaurant = restaurant
        return cell
    }
    
}
