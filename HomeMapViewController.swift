//
//  HomeMapViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import MapKit

class HomeMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var center = CLLocationCoordinate2D()
    var annotations = [MKPointAnnotation]()
    
    
    //MARK: - Actions & Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    


    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view?.canShowCallout = true
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let index = (self.annotations as NSArray).indexOfObject(view.annotation!)
//        let index >= 0 {
//            self.showDetailsForResult(self.results[index])
//        }
    }
    
//    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        if self.center == nil {
//            self.center = mapView.region.center
//        } else {
//            let before = CLLocationCoordinate2D(latitude: self.center.latitude, longitude: self.center.longitude)
//            let nowCenter = mapView.region.center
//            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
//        }
//    }

    //MARK: - JSON
    func loadInitialJsonData() {
        
        
    }
}

extension MKMapViewDelegate {

}