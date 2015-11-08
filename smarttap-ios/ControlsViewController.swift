//******************************************************************************
//  ControlsViewController.swift
//  smarttap-ios
//
//  Copyright (c) 2015 smarttap. All rights reserved.
//******************************************************************************

import UIKit

class ControlsViewController: UIViewController {

    //**************************************************************************
    // MARK: Attributes (Public)
    //**************************************************************************
    
    @IBOutlet var litersUsed: UILabel!
    @IBOutlet var flowChart: UIButton!
    
    // Various error codes.
    static let errorStatisticsCode  = 1
    
    var parentVC: MainViewController? = nil
    
    //**************************************************************************
    // MARK: Attributes (Internal)
    //**************************************************************************
    
    // The JSON connection used to manage JSON API requests / responses to and
    // from the password reset server.
    internal static var _connection: JSONConnection = JSONConnection()
    
    //**************************************************************************
    // MARK: Attributes (Private)
    //**************************************************************************
    
    private static var _errorMsgConnectionFailure: String = "Connection failed."
    private static var _errorMsgErrorResponse: String     = "Connection succeeded, but an error response was received."
    
    private static let _urlFlow = "http://api-m2x.att.com/v2/devices/8ade04c716be77744a2488c9880f1a42/streams/flow"
    private static let _urlChart = "http://api-m2x.att.com/v2/charts"
    
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

    @IBAction func litersUsed(sender: AnyObject) {
        
        ControlsViewController._connection.get(
            ControlsViewController._urlFlow,
            parameters: nil,
            callback: { (json, httpResponse, error) -> Void in
                
                var response: [String:AnyObject] = [String:AnyObject]()
                var err: NSError?
                if (error == nil) {
                    
                    // If the connection returned an error response, pass back a
                    // corresponding NSError to the caller.
                    
                    if (httpResponse!.statusCode != 200) {
                        
                        var errDomain: String
                        if (json != nil && httpResponse!.statusCode == 422) {
                            errDomain = JSONErrors.firstError(json as! NSDictionary)
                        }
                        else {
                            errDomain = ControlsViewController._errorMsgErrorResponse
                        }
                        
                        err = NSError(
                            domain: errDomain,
                            code: ControlsViewController.errorStatisticsCode,
                            userInfo: nil)
                        print("litersUsed: " + err!.domain)
                    }
                    else {
                        response = json as! [String:AnyObject]
                        print(response)
                        dispatch_async(dispatch_get_main_queue()) {
                            if (response["value"] != nil) {
                                let mL = Float(String(response["value"]!))! / 0.450
                                //self.litersUsed.text = String(mL) + " mL"
                                self.litersUsed.text = String(format: "%.2f", mL) + " mL"
                            }
                        }
                    }
                }
                else {
                    // Return a generic error.
                    err = NSError(
                        domain: ControlsViewController._errorMsgConnectionFailure,
                        code: ControlsViewController.errorStatisticsCode,
                        userInfo: nil)
                    print("litersUsed: " + err!.domain)
                }
        })
    }
    
    @IBAction func flowChart(sender: AnyObject) {
        
        ControlsViewController._connection.get(
            ControlsViewController._urlChart,
            parameters: nil,
            callback: { (json, httpResponse, error) -> Void in
                
                var response: [String:AnyObject] = [String:AnyObject]()
                var err: NSError?
                if (error == nil) {
                    
                    // If the connection returned an error response, pass back a
                    // corresponding NSError to the caller.
                    
                    if (httpResponse!.statusCode != 200) {
                        
                        var errDomain: String
                        if (json != nil && httpResponse!.statusCode == 422) {
                            errDomain = JSONErrors.firstError(json as! NSDictionary)
                        }
                        else {
                            errDomain = ControlsViewController._errorMsgErrorResponse
                        }
                        
                        err = NSError(
                            domain: errDomain,
                            code: ControlsViewController.errorStatisticsCode,
                            userInfo: nil)
                        print("chartFlow: " + err!.domain)
                    }
                    else {
                        response = json as! [String:AnyObject]
                        print(response)
                        let charts = response["charts"] as! [[String:AnyObject]]
                        let render = charts[0]["render"] as! [String:AnyObject]
                        dispatch_async(dispatch_get_main_queue()) {
                            let url = NSURL(string: render["png"] as! String)
                            UIApplication.sharedApplication().openURL(url!)
                        }
                    }
                }
                else {
                    // Return a generic error.
                    err = NSError(
                        domain: ControlsViewController._errorMsgConnectionFailure,
                        code: ControlsViewController.errorStatisticsCode,
                        userInfo: nil)
                    print("chartFlow: " + err!.domain)
                }
        })
    }
    
    @IBAction func back(sender: AnyObject) {
        
        self.parentVC!.isForced = false
        self.dismissViewControllerAnimated(true, completion: nil)
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

        // Do any additional setup after loading the view.
    }
}
