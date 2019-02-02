//
//  HomeViewController.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/19/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeViewController: UIViewController, UISearchBarDelegate, HandleMapSearch {

  @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var locationManager = CLLocationManager()
    var db: Firestore!
    var annotations: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        gettingAnotation()
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
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.00625, longitudeDelta: 0.00625)
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
    
    func gettingAnotation(){
        let usersRef = db.collection("users")
        usersRef.whereField("address", isGreaterThanOrEqualTo: "")
            .getDocuments() { [unowned self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.putAnnotationFor(document.data()["address"]! as! String, document.data()["names"]! as! String )
                    }
                }
        }
    }
    
    func putAnnotationFor(_ address: String, _ title: String){
        let annotation = MKPointAnnotation()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start {[unowned self] response, _ in
            guard let response = response else { return }
            annotation.coordinate = response.mapItems[0].placemark.coordinate
            annotation.title = title
            annotation.subtitle = response.mapItems[0].placemark.title
            self.mapView.addAnnotation(annotation)
        }
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.00625, longitudeDelta: 0.00625)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}
