//
//  FavoritesListViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class FavoritesListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var noFavoritesLabelView: UIView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    // MARK: - Properties
    private let animations = [AnimationType.from(direction: .right, offset: 120.0), AnimationType.zoom(scale: 0.5)]
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnimationManager.moveButtonsOffScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
        refreshTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnimationManager.animateButtonOntoScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
    }

    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToSearchFromDetail(unwindSegue: UIStoryboardSegue) {
        perform(#selector(dismissToSearchVC), with: nil, afterDelay: 0.0)
    }
    
    // MARK: - Methods
    @objc func refreshTable() {
        self.tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations)
        tableView.refreshControl?.endRefreshing()
    }
    
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
        // Add this here to ensure the most recent fetchedResultsController exists.
        RestaurantController.shared.fetchAllRestaurants()
        checkForFavorites()
    }
    
    func checkForFavorites() {
        if RestaurantController.shared.fetchedResultsController.fetchedObjects?.count == 0 {
            noFavoritesLabelView.isHidden = false
            noFavoritesLabel.isHidden = false
        }
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
