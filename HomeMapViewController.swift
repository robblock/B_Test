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
    
    var locationManager = CLLocationManager()
    
    //MARK: - Actions & Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var delegate: MKMapViewDelegate?
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let geoCoder = CLGeocoder()
    }



    //MARK: - JSON
    func loadInitialJsonData() {
        
        
    }
}

extension MKMapViewDelegate {

}