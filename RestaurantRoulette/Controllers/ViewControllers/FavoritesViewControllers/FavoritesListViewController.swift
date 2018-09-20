//
//  FavoritesListViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CoreData

class FavoritesListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
        
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ButtonAnimationManager.moveButtonsOffScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ButtonAnimationManager.animateButtonOntoScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
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
            
            let restaurant = RestaurantController.shared.fetchedResultsController.object(at: indexPath)
            destinationVC.title = restaurant.name
            destinationVC.restaurant = restaurant
        }
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource Conformance
extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        RestaurantController.shared.fetchedResultsController.delegate = self
        RestaurantController.shared.fetchAllRestaurants()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        let restaurant = RestaurantController.shared.fetchedResultsController.object(at: indexPath)
        cell.restaurant = restaurant
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate Conformance
extension FavoritesListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}
