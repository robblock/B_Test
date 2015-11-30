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

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Receiving Data From HomeViewController
    var merchantId = String()
    var merchantLocation = PFGeoPoint()
    var merchantName = String()
    
    var menuCatagory = String()
    
    var menuList = [String]()
    var drinkImages = [UIImage]()
    
    var merchantObject = [PFObject]()
    
    var userLocation = UserLocation()
    var locationManager:CLLocationManager = CLLocationManager()
    

    //MARK: - Likes
    var likeBond: Observable<[PFUser]?>! = Observable(nil)
    var parseHelper = ParseHelper()
    
    var likeDisposable: DisposableType?
    
    var merchant: Merchant? {
        didSet {
            
            likeDisposable!.dispose()
            
            
            if let merchant = merchant {
                likeDisposable = merchant.likes.observe { (value: [PFUser]?) -> () in
                    if let value = value {
                        self.likesButton.selected = value.contains(PFUser.currentUser()!)
                        self.likesImageView.hidden = (value.count == 0)
                    } else {
                        self.likesLabel.text = ""
                        self.likesButton.selected = false
                        self.likesImageView.hidden = true
                    }
                    
                }
            }
        }
    }

    
    //MARK: Initialization
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        
//        let likeBonds = likeBond.observe() { [unowned self] likeList in
//            if let likeList = likeList {
//                    self.likesButton.selected = likeList.contains(PFUser.currentUser()!)
//                    self.likesImageView.hidden = (likeList.count == 0)
//            } else {
//                    // if there is no list of users that like this post, reset everything
////                    
////                    self.likesButton.selected = false
////                    self.likesImageView.hidden = true
//                
//                }
//            }
//        }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        print(merchantId)

        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        //Parse
        merchant?.fetchLikes()
        merchantNameLabel.text = merchantName

        
        //Retrieve Merchant & Annotate Map
        let aLocation: CLLocationCoordinate2D = merchantLocation.location()
        let aLocationLongitude = merchantLocation.longitude
        let aLocationLatitude = merchantLocation.latitude
        
        let clLocation: CLLocation = CLLocation(latitude: aLocationLatitude, longitude: aLocationLongitude)
        
        
        //TODO: Zoom in on pin
        let latDelta:CLLocationDegrees = 0.05
        let longDelta:CLLocationDegrees = 0.05
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
        
        self.tableView.reloadData()

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
        
        let index = self.tableView.indexPathForSelectedRow?.row
        
        performSegueWithIdentifier("MerchantSubCatagory", sender: self)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MerchantSubCatagory") {
            if let nvc: DetailSubCatagoryTableViewController = segue.destinationViewController as? DetailSubCatagoryTableViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    let merchant = merchantObject[blogIndex] as PFObject
                    
                    nvc.merchantId = merchant.objectId!
                    
                }
            }
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        merchant!.toggleLikePost(PFUser.currentUser()!)
        print("User Liked \(merchantId)")
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
