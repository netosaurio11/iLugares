//
//  HomeViewController.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/19/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeViewController: UIViewController, UISearchBarDelegate, HandleMapSearch {

    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
  @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    func saveSession(for user: String, _ password: String) {
        let persistent = Persistent()
        if persistent.saveSession(user, password) {
            print("Session saved with success")
        } else {
            print("Error saving session")
        }
    }

    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        let searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController.searchResultsUpdater = locationSearchTable
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for places"
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        present(searchController, animated: true, completion: nil)
        
    }
    
    
}
