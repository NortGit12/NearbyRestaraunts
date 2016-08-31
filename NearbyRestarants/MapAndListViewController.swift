//
//  MapAndListViewController.swift
//  NearbyRestarants
//
//  Created by Jeff Norton on 8/31/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapAndListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var resultsMapItems: [MKMapItem]?
    
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 40.761766, longitude: -111.890274)
    let regionRadius: CLLocationDistance = 1000
    var currentCity = String()
    var currentPostalCode = String()
    
    //==================================================
    // MARK: - General
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self

//        centerMapOnLocation(self.initialLocation)
        
        setupLocationService()
    }
    
    //==================================================
    // MARK: - UITableViewDataSource
    //==================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.resultsMapItems?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mapListCell", forIndexPath: indexPath)
        
        guard let resultsMapItems = self.resultsMapItems else { return UITableViewCell() }
        
        let resultItem = resultsMapItems[indexPath.row]
        cell.textLabel?.text = resultItem.name
        
        return cell
    }
    
    //==================================================
    // MARK: - CLLocationManagerDelegate
    //==================================================
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = manager.location else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let lastLocation = locations.last {
                
                let centerOfCurrentLocation = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                print("\n### Locations = \(centerOfCurrentLocation) \(centerOfCurrentLocation) ###")
                
                // Example's code
                //            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                //
                //            self.mapView.setRegion(region, animated: true)
                
                // Other code
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerOfCurrentLocation, self.regionRadius * 2.0, self.regionRadius * 2.0)
                
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.locationManager.stopUpdatingLocation()
                
                if let placemarks = placemarks {
                    
                    let currentPlacemark = placemarks[0]
//                    self.displayLocationInfo(currentPlacemark)
                    
                    guard let currentCity = currentPlacemark.locality, currentPostalCode = currentPlacemark.postalCode else { return }
                    
                    self.currentCity = currentCity
                    self.currentPostalCode = currentPostalCode
                    
                    self.title = "\(currentCity) - \(currentPostalCode)"
                }
            }
            
            self.mapView.showsUserLocation = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        self.locationManager.stopUpdatingLocation()
        
        print("Errors: \(error.localizedDescription)")
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func setupLocationService() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        print("\nplacemark.locality = \(placemark.locality)")
        print("placemark.postalCode = \(placemark.postalCode)")
        print("placemark.administrativeArea = \(placemark.administrativeArea)")
        print("placemark.country = \(placemark.country)")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.resultsMapItems = nil
        clearMap()
        
        guard let searchText = searchBar.text where searchText.characters.count > 0 else { return }
        
        print("\n\n******************** New Search (\(searchText)) ********************\n")
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response, error) in
            
            if error != nil {
                
                NSLog("Error: Problem occurred in search.  \(error?.localizedDescription)")
                
            } else if response?.mapItems.count == 0 {
                
                NSLog("No items found.")
                
            } else {
                
                if let resultsMapItems = response?.mapItems {
                    
                    NSLog("MapItems = \(resultsMapItems)")
                    
                    self.resultsMapItems = resultsMapItems
                    
                    for item in resultsMapItems {
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.searchBar.endEditing(true)
                        self.mapView.reloadInputViews()
                        self.resultsTableView.reloadData()
                    })
                }
            }
        }
    }
    
    func clearMap() {
        
        for annotation in self.mapView.annotations {
            
            self.mapView.removeAnnotation(annotation)
        }
        
        self.mapView.reloadInputViews()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
