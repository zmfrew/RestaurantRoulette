//
//  RandomRestaurantMapViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit

class RandomRestaurantMapViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var restaurant: Restaurant?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform animation with roulette wheel.
        setupTableView()
        setupMapView()
    }
    
    // MARK: - Actions
    @IBAction func unwindToSearchFromMap(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSearchFromMapToBookmarks(unwindSegue: UIStoryboardSegue) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource Conformance
extension RandomRestaurantMapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "randomMapCell", for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        
        cell.restaurant = restaurant
        return cell
    }
    
}

// MARK: - MKMapViewDelegate Conformance
extension RandomRestaurantMapViewController: MKMapViewDelegate {
    
    func setupMapView() {
        mapView.delegate = self
        
        guard let restaurant = restaurant else { return }
        
        let center = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(restaurant)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Restaurant else { return nil } // FIXME: - Change to CDYelpBusiness
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)))
            mapsButton.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
            mapsButton.setTitle("Driving Directions", for: UIControlState())
            view.rightCalloutAccessoryView = mapsButton
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Restaurant// FIXME: - Change to CDYelpBusiness
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
