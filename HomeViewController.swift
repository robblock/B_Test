//
//  HomeViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allMerchants = [MerchantLocations]()
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    //MARK: - TableView DataSource & Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    

    //MARK: - JSON
    func loadInitialJsonData() {
        
        
    }
    
    
    //MARK: - Actions & Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
}

extension MKMapViewDelegate {

}