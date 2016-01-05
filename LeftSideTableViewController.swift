//
//  LeftSideTableViewController.swift
//  beacons_test
//
//  Created by Rob Block on 12/18/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import Social

class LeftSideTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    
    var navImageView:UIImageView!
    
    var usersImage = UIImage()
    var firstName = String()
    var lastName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clearColor()
        tableView.scrollEnabled = false
        navImageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        
        let query = PFQuery(className: "_User")
        query.fromPinWithName("userImage")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let userImage = objects as? [PFObject]! {
                for image in userImage! {
                    var imageFile = image["userImage"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.navImageView.image = UIImage(data: imageData)!
                            }
                        }
                    })
                }
                self.tableView.reloadData()
            }
        }
        
        let nameQuery = PFQuery(className: "_User")
        nameQuery.fromLocalDatastore()
        nameQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let usersInfo = objects as? [PFObject]! {
                for name in usersInfo {
                    
                    let usersFirstName = name["firstName"] as! String
                    let usersLastName = name["lastName"] as! String
                    
                    self.firstName = usersFirstName
                    self.lastName = usersLastName
                }
                self.tableView.reloadData()
            }
        }
        

    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        setupNavbar()
    }
    
    func setupNavbar() {
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
    
        var leftBarImageView:UIBarButtonItem = UIBarButtonItem(customView: navImageView)
        
        navImageView.contentMode = .ScaleAspectFill
        navImageView.layer.borderWidth = 1.0
        navImageView.layer.masksToBounds = true
        navImageView.layer.borderColor = UIColor.clearColor().CGColor
        navImageView.layer.cornerRadius = navImageView.frame.size.width / 2
        navImageView.clipsToBounds = true
        
        navigationItem.setLeftBarButtonItem(leftBarImageView, animated: true)
        
        navigationItem.title = firstName + lastName
        navigationItem.prompt = "tests"
    }
    
    
    // MARK: - TableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case(0,1):
            cell.textLabel!.text = "User Profile"
        case(0,3):

            cell.textLabel!.text = "Give Us Feedback"
        case(0,4):
            cell.textLabel!.text = "Share"
        case(1,2):
            cell.textLabel!.text = "Logout"
            
        default:
           break
        }

        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.whiteColor()
        
        selectedCell.selectedBackgroundView = bgColorView
        
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case(0,1):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Profile") as! UserProfileViewController
            self.presentViewController(vc, animated: true, completion: nil)
        case(0,3):
            emailFeedback()
            print("Feedback")
        case(0,4):
            social()
            print("Share")
        case(1,1):
            logOut()
            print("Logout")
        default:
            print("test")
        }
    }
    

    //MARK: - TableView Functions
    func logOut() {
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! ViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    
    func popOver() {
        var popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idPopover") as! PopoverViewController
        popover.modalPresentationStyle = UIModalPresentationStyle.Popover
        popover.popoverPresentationController?.delegate = self
        
        popover.popoverPresentationController?.permittedArrowDirections = .Unknown
        popover.preferredContentSize = CGSizeMake(self.view.frame.width, 300)
        self.presentViewController(popover, animated: true, completion: nil)
        
    }
    
    func emailFeedback() {
        let alert = UIAlertController(title: "Feedback", message: "We need your feedback to give you the best possible experience", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["robblock@sbcglobal.net"])
                mail.setSubject("ORDR APP Feeback")
                mail.setMessageBody("<p>You're app rocks!</p>", isHTML: true)
                
                self.presentViewController(mail, animated: true, completion: nil)
            } else {
                // show failure alert
            }
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func social() {
        let alert = UIAlertController(title: "Help us Spread", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let fbAction = UIAlertAction(title: "Facebook", style: .Default) { (action: UIAlertAction) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                self.presentViewController(fbShare, animated: true, completion: nil)
                
            } else {
                var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: { (action: UIAlertAction) -> Void in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setSubject("Check out this awesome app I've been using")
                mail.setMessageBody("<p>Download it now!</p>", isHTML: true)
                
                self.presentViewController(mail, animated: true, completion: nil)
            } else {
                // show failure alert
            }
        })
        
        let txtMessageAction = UIAlertAction(title: "Text Message", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            if (MFMessageComposeViewController.canSendText()) {
                let messageVC = MFMessageComposeViewController()
                messageVC.messageComposeDelegate = self
                messageVC.body = "Check out this App"
                
                self.presentViewController(messageVC, animated: true, completion: nil)
            } else {
                // show failure alert
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in
        }

        
        alert.addAction(fbAction)
        alert.addAction(emailAction)
        alert.addAction(txtMessageAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func applyImageBackgroundToTheNavigationBar() {
        // These background images contain a small pattern which is displayed
        // in the lower right corner of the navigation bar.
        var backgroundImageForDefaultBarMetrics = UIImage(named: "NavigationBarDefault")!
        var backgroundImageForLandscapePhoneBarMetrics = UIImage(named: "NavigationBarLandscapePhone")!
        
        // Both of the above images are smaller than the navigation bar's
        // size.  To enable the images to resize gracefully while keeping their
        // content pinned to the bottom right corner of the bar, the images are
        // converted into resizable images width edge insets extending from the
        // bottom up to the second row of pixels from the top, and from the
        // right over to the second column of pixels from the left.  This results
        // in the topmost and leftmost pixels being stretched when the images
        // are resized.  Not coincidentally, the pixels in these rows/columns
        // are empty.
        backgroundImageForDefaultBarMetrics = backgroundImageForDefaultBarMetrics.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, backgroundImageForDefaultBarMetrics.size.height - 1, backgroundImageForDefaultBarMetrics.size.width - 1))
        backgroundImageForLandscapePhoneBarMetrics = backgroundImageForLandscapePhoneBarMetrics.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, backgroundImageForLandscapePhoneBarMetrics.size.height - 1, backgroundImageForLandscapePhoneBarMetrics.size.width - 1))
        
        // You should use the appearance proxy to customize the appearance of
        // UIKit elements.  However changes made to an element's appearance
        // proxy do not effect any existing instances of that element currently
        // in the view hierarchy.  Normally this is not an issue because you
        // will likely be performing your appearance customizations in
        // -application:didFinishLaunchingWithOptions:.  However, this example
        // allows you to toggle between appearances at runtime which necessitates
        // applying appearance customizations directly to the navigation bar.
        /* id navigationBarAppearance = [UINavigationBar appearanceWhenContainedIn:[NavigationController class], nil]; */
        let navigationBarAppearance = self.navigationController?.navigationBar
        
        // The bar metrics associated with a background image determine when it
        // is used.  The background image associated with the Default bar metrics
        // is used when a more suitable background image can not be found.
        navigationBarAppearance?.setBackgroundImage(backgroundImageForDefaultBarMetrics, forBarMetrics: .Default)
        // The background image associated with the LandscapePhone bar metrics
        // is used by the shorter variant of the navigation bar that is used on
        // iPhone when in landscape.
        navigationBarAppearance?.setBackgroundImage(backgroundImageForLandscapePhoneBarMetrics, forBarMetrics: .Compact)
    }
    
    
}
