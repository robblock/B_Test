//
//  DetailViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Receiving Data From HomeViewController
    var merchantId = String()
    var merchantLocation = PFGeoPoint()
    
    
    var menuList = [String]()
    var drinkImages = [UIImage]()
    
    var merchantObject = [PFObject]()
    
    var userLocation = UserLocation()
    var locationManager:CLLocationManager = CLLocationManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(merchantId)
        print(merchantLocation)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        //Parse
        
        
        self.tableView.reloadData()
    

        //Retrieve Merchant & Annotate Map
        
        
        let aLocation: CLLocationCoordinate2D = merchantLocation.location()
        let aLocationLongitude = merchantLocation.longitude
        let aLocationLatitude = merchantLocation.latitude
        
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    //MARK: - Parse

    
    //MARK: - MapView
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
    
    @IBAction func onCrossHairButton(sender: AnyObject) {
        let center = self.userLocation.location.coordinate
        let region = MKCoordinateRegion(center: center, span: self.mapView.region.span)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    //MARK: - TableView DataSource & Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let menuObject = merchantObject[indexPath.row] as PFObject
        
        cell.textLabel?.text = menuObject.objectForKey("Drinks") as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        print("Selected cell # \(indexPath.row)!")
        
        
        
        
    }
    

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "SubCatagory" {
//            if let destination = segue.destinationViewController as? DetailSubCatagoryTableViewController {
//                if let blogIndex = tableView.indexPathForSelectedRow?.row {
//                    let menuItem = merchantObject[blogIndex] as PFObject
//                    
//                }
//            }
//        }
//    }
    

    //MARK: - Actions & Outlets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
}

extension PFGeoPoint {
    func location() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
