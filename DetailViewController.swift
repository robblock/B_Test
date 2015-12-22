//
//  DetailViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import MapKit
import Bond

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label


class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    //Receiving Data From HomeViewController
    var merchantId = String()
    var merchantLocation = PFGeoPoint()
    var merchantName = String()
    
    var merchantObjId = String()
    
    var menuCatagory = String()
    
    var menuList = [String]()
    var drinkImages = [UIImage]()
    
    var merchantObject = [PFObject]()
    
    var userLocation = UserLocation()
    var locationManager:CLLocationManager = CLLocationManager()
    
    
    var testMenu = [PFObject]()

    //MARK: - Likes
    var likeBond: Observable<[PFUser]?>! = Observable(nil)
    var parseHelper = ParseHelper()
    
    var likeDisposable: DisposableType?
    var merchant = Merchant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
        
        let query = PFQuery(className: "Restaurants_Menus_Catagories")
        query.whereKey("merchant_id", equalTo: merchantId)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                        self.merchantObject = completeMerchantObject
                        
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        merchant.fetchLikes()
        merchantNameLabel.text = merchantName
        
        
        
        //Retrieve Merchant & Annotate Map
        let aLocation: CLLocationCoordinate2D = merchantLocation.location()
        let aLocationLongitude = merchantLocation.longitude
        let aLocationLatitude = merchantLocation.latitude
        
        let clLocation: CLLocation = CLLocation(latitude: aLocationLatitude, longitude: aLocationLongitude)
        
        
        //TODO: Zoom in on pin
        let latDelta:CLLocationDegrees = 0.0005
        let longDelta:CLLocationDegrees = 0.0005
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(aLocation, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        let pin = CLLocationCoordinate2DMake(aLocationLatitude, aLocationLongitude)
        annotation.coordinate = pin
        
        self.mapView.addAnnotation(annotation)
        
        
        //ReverseGeocode merchantLocation to display to user
        parseHelper.reverseGeocodeLocation(clLocation) { (placemark, error) -> Void in
            self.merchantAddressLabel.text = self.parseHelper.addressFromPlacemark(placemark!)
            
        }
        

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    //MARK: - Parse
    //TODO: Add a like/save feature, with instagram heart, where users will be able to save a location
    
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
        return merchantObject.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let menuObject = merchantObject[indexPath.row] as PFObject
        
        cell.textLabel?.text = menuObject.objectForKey("menu_id") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        print("Selected cell # \(indexPath.row)!")
        
        let index = self.tableView.indexPathForSelectedRow?.row
        
        performSegueWithIdentifier("SubCatagory", sender: self)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SubCatagory") {
            if let nvc: DetailSubCatagoryTableViewController = segue.destinationViewController as? DetailSubCatagoryTableViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    let merchant = merchantObject[blogIndex] as PFObject
                    
                    nvc.merchantId = merchant.objectForKey("merchant_id") as! String
                    nvc.menuCatagory = merchant.objectForKey("catagory_id") as! String
                }
            }
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
            
        self.likesButton.setImage(UIImage(named: "heart_selected"), forState: UIControlState.Selected)
        
        self.parseHelper.saveLike(PFUser.currentUser()!, objectID: self.merchantObjId)
        
        //            self.likesButton.setImage(UIImage(named: "heart_selected"), forState: UIControlState.Selected)
        //
        //            self.parseHelper.unlike(PFUser.currentUser()!, objectID: self.merchantObjId)

    }
    
    //MARK: - Actions & Outlets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var likesImageView: UIImageView!

    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantAddressLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var merchantLabelView: UIView!
    
}

extension PFGeoPoint {
    func location() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

extension PFObject {
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}
