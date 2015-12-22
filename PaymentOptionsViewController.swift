//
//  PaymentOptionsViewController.swift
//  beacons_test
//
//  Created by Rob Block on 12/20/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import PassKit

class PaymentOptionsViewController: UIViewController {
    
    let supportedPaymentNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkAmex, PKPaymentNetworkMasterCard]
    let ordrMerchantID = "merchant.com.ordr.app"

    
    //Pass name & Price to this controller
    var itemName = String()
    var itemPrice = NSDecimalNumber()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(supportedPaymentNetworks)
    
    }
    
    @IBAction func purchase(sender: UIButton) {
        let request = PKPaymentRequest()
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        
        request.merchantIdentifier = ordrMerchantID
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        //Need twice?
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: itemName, amount: itemPrice),
            PKPaymentSummaryItem(label: itemName, amount: itemPrice)
        ]
        
        
        self.presentViewController(applePayController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var applePayButton: UIButton!
    
}

extension PaymentOptionsViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
