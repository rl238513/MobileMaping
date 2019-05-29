//
//  ViewController.swift
//  MobileMaping
//
//  Created by EDUARDO MENDOZA on 4/12/19.
//  Copyright © 2019 EDUARDO MENDOZA. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchBar: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var parks: [MKMapItem] = []
    var initialRegion:MKCoordinateRegion!
    var isInitialMapLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    @IBAction func zoom(_ sender: Any) {
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: coordinateSpan)
        mapView.setRegion(region, animated: true)
        
        parks.removeAll()
        let request = MKLocalSearch.Request()
        let item = searchBar.text
        request.naturalLanguageQuery = item
        
//        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: coordinateSpan)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            if let response = response {
                for mapItem in response.mapItems {
                    self.parks.append(mapItem)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    @IBAction func search(_ sender: Any) {    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation){
            return nil
        }
        
        var pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if let title = annotation.title, let actualTitle = title {
            if actualTitle == "parky McParkface"{
                
            }else{
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            }
        }
        
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        let addButton = UIButton(type: .contactAdd)
        pin.leftCalloutAccessoryView = addButton
        
        return pin 
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isInitialMapLoaded{
            initialRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: mapView.region.span)
            isInitialMapLoaded = false
        }
    }
}



































