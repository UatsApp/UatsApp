//
//  UatsAppVC.swift
//  UatsApp
//
//  Created by Student on 23/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit

class UatsAppVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // @IBOutlet weak var logout: UIButton!
    
    @IBOutlet var logoutBtn: UIButton!
    
    @IBAction func logoutAction(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)

        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
                self.performSegueWithIdentifier("goto_login", sender: logoutBtn)
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}