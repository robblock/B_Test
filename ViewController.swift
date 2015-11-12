//
//  ViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse
import ParseUI



class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(PFUser.currentUser() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            
            //Setting Login Screen Fields
            loginViewController.fields = PFLogInFields(rawValue:
                PFLogInFields.UsernameAndPassword.rawValue |
                PFLogInFields.LogInButton.rawValue |
                PFLogInFields.PasswordForgotten .rawValue |
                PFLogInFields.SignUpButton.rawValue |
                PFLogInFields.Facebook.rawValue |
                PFLogInFields.Twitter.rawValue)
            
            loginViewController.emailAsUsername = true //Discuss
            loginViewController.signUpController?.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            
            self.presentViewController(loginViewController, animated: false, completion: nil)
            
        } else {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    
        //Alert the user when they are successfully logged in
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're Logged in", message: "Welcome to ORDR", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "ok", style: .Default) { (ACTION) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

