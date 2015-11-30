//
//  BeaconHomeViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/19/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class BeaconHomeViewController: UIViewController {

    var beacons = [CLBeacon]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    
//    
//
//
    @IBOutlet weak var tableView: UITableView!
//
//}
//
//extension BeaconHomeViewController: UITableViewDataSource {
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(beacons != nil) {
//            return beacons.count
//        } else {
//            return 0
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
//        
//        if(cell == nil) {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Myidentifier")
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//        }
//        let beacon:CLBeacon = beacons[indexPath.row]
//        var proximityLabel:String = ""
//        
//        switch beacon.proximity {
//        case CLProximity.Far:
//            proximityLabel = "Far"
//        case CLProximity.Near:
//            proximityLabel = "Near"
//        case CLProximity.Immediate:
//            proximityLabel = "Immediate"
//        case CLProximity.Unknown:
//            proximityLabel = "Uknown"
//        }
//        
//        cell.textLabel!.text = proximityLabel
//        
//        let detailLabel:String = "Major: " + "Minor:" + "RSSI:" + "UUID"
//        cell.detailTextLabel!.text = detailLabel
//        
//        return cell
//        
//    }
//    
//    
}