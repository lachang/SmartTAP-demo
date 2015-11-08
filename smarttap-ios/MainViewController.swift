//******************************************************************************
//  MainViewController.swift
//  smarttap-ios
//
//  Copyright (c) 2015 smarttap. All rights reserved.
//******************************************************************************

import UIKit

class MainViewController: UIViewController,
GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate {

    //**************************************************************************
    // MARK: Attributes (Public)
    //**************************************************************************
    
    @IBOutlet var signalStrength: UILabel!
    @IBOutlet var forceButton: UIButton!
    
    var isForced = false
    
    var placeManager: GMBLPlaceManager!
    var commManager: GMBLCommunicationManager!

    //**************************************************************************
    // MARK: Attributes (Internal)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Attributes (Private)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Class Methods (Public)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Class Methods (Internal)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Class Methods (Private)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Instance Methods (Public)
    //**************************************************************************
    
    @IBAction func forceControls(sender: AnyObject) {
        
        if (!isForced) {
            isForced = true
        }
        else {
            isForced = false
        }
        
        self.performSegueWithIdentifier("showButtons", sender: self)
    }
    
    //**************************************************************************
    // MARK: Instance Methods (Internal)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: Instance Methods (Private)
    //**************************************************************************
    
    //**************************************************************************
    // MARK: UIViewController
    //**************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        placeManager = GMBLPlaceManager()
        commManager = GMBLCommunicationManager()
        
        placeManager.delegate = self
        commManager.delegate = self
        
        print("Loaded delegates")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showButtons" {
            let controlsVC =
            segue.destinationViewController as! ControlsViewController
            controlsVC.parentVC = self
        }
    }
    
    //**************************************************************************
    // MARK: Gimbal
    //**************************************************************************
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        print(">>didBeginVisit")
    }
    
    func placeManager(manager: GMBLPlaceManager!, didReceiveBeaconSighting sighting: GMBLBeaconSighting!, forVisits visits: [AnyObject]!) {
        print(">>sawBeacon: \(sighting.RSSI)")
        self.signalStrength.text = String(sighting.RSSI)
        
        if (!isForced) {
            if (sighting.RSSI > -72) {
                if (self.presentedViewController == nil) {
                    self.performSegueWithIdentifier("showButtons", sender: self)
                }
            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        print(">>didEndVisit")
    }

    func communicationManager(manager: GMBLCommunicationManager!, presentLocalNotificationsForCommunications communications: [AnyObject]!, forVisit visit: GMBLVisit!) -> [AnyObject]! {
        
        if communications is [GMBLCommunication] {
            print(">>Event!")
            for comm in communications {
                print(comm.title)
            }
        }
        
        return communications
    }
}

