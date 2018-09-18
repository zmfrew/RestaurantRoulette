//
//  FavoritesListViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {

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
    
    @IBAction func unwindToSearchFromDetail(unwindSegue: UIStoryboardSegue) {
        perform(#selector(dismissToSearchVC), with: nil, afterDelay: 0.0)
    }

    // MARK: - Methods
    @objc func dismissToSearchVC() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavoriteDetail" {
            guard let destinationVC = segue.destination as? FavoriteDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let restaurant = RestaurantController.shared.restaurants[indexPath.row]
            destinationVC.title = restaurant.name
            destinationVC.restaurant = restaurant
        }
    }
    
}

extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantController.shared.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let restaurant = RestaurantController.shared.restaurants[indexPath.row]
        cell.restaurant = restaurant
        return cell
    }
    
}
