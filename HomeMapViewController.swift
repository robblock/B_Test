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
    var annotations = [CLLocationCoordinate2D]()
    var parseHelper = ParseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Restaurants_Menus")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let geoPoint = object["Location"] as? PFGeoPoint
                    
                    let aLocation: CLLocationCoordinate2D = geoPoint!.location()
                    self.annotations.append(aLocation)
                    print(self.annotations)
                    let aLocationLongitude = geoPoint!.longitude
                    let aLocationLatitude = geoPoint!.latitude
                    
                    //TODO: Zoom in on pin
                    let latDelta:CLLocationDegrees = 0.1
                    let longDelta:CLLocationDegrees = 0.1
                    let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                    let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(aLocation, theSpan)
                    self.mapView.setRegion(theRegion, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    let pin = CLLocationCoordinate2DMake(aLocationLatitude, aLocationLongitude)
                    annotation.coordinate = pin
                    
                    self.mapView.addAnnotation(annotation)
                }
                
                self.mapView.reloadInputViews()
            }
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
     
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    


    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    


    //MARK: - Actions & Outlets
    @IBOutlet weak var mapView: MKMapView!
    
}