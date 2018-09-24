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
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    // MARK: - Properties
    var business: CDYelpBusiness?
    var businesses: [CDYelpBusiness?]?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
        ButtonAnimationManager.moveButtonsOffScreen(leftButton: searchButton, centerButton: randomButton, rightButton: favoritesButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ButtonAnimationManager.animateButtonOntoScreen(leftButton: searchButton, centerButton: randomButton, rightButton: favoritesButton)
    }
    
    // MARK: - Actions
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        selectRandomBusiness()
        self.title = business?.title
        setupMapView()
        tableView.reloadData()
    }
    
    @IBAction func unwindToSearchFromMap(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSearchFromMapToBookmarks(unwindSegue: UIStoryboardSegue) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    func selectRandomBusiness() {
        guard let businesses = businesses else { return }
        let randomIndex = Int(arc4random_uniform(UInt32(businesses.count)))
        business = businesses[randomIndex]
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "randomMapCell", for: indexPath) as? BusinessTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.business = business
        return cell
    }
    
}

// MARK: - MKMapViewDelegate Conformance
extension RandomRestaurantMapViewController: MKMapViewDelegate {
    
    func setupMapView() {
        mapView.delegate = self
        
        guard let business = business else { return }
        
        if let latitude = business.coordinates?.latitude,
            let longitude = business.coordinates?.longitude {
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            
            mapView.addAnnotation(business)
        } else {
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = business.name
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                if let error = error {
                    print("Error occurred with MKLocalSearch: \(error.localizedDescription).")
                    return
                }
                
                guard let response = response else { return }
                // Set the business' coordinate = to this.
                self.business?.coordinates?.latitude = response.mapItems.first?.placemark.coordinate.latitude
                self.business?.coordinates?.longitude = response.mapItems.first?.placemark.coordinate.longitude
            }
            return
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CDYelpBusiness else { return nil }
        
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
        let location = view.annotation as! CDYelpBusiness
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
