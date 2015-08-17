//
//  UatsAppVC.swift
//  UatsApp
//
//  Created by Student on 23/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class UatsAppVC: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if loggedUserID == -1000 {
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var user : String = prefs.valueForKey("USERNAME") as! String
            Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/returnLoggedUseID.php", parameters: ["username" : "\(user)"], encoding: .JSON).responseJSON {
                _, _, JSON, _ in
                if JSON != nil{
                    loggedUserID = JSON?.valueForKey("loggedUseID") as! Int
                    socketManager.sharedSocket.socket.connect()
                }
            }
        }else{
            socketManager.sharedSocket.socket.connect()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var LoggedUseUserName = prefs.valueForKey("USERNAME") as! String
        
        self.navigationItem.title = LoggedUseUserName
    }
    
    
    @IBOutlet var logoutBtn: UIButton!
    
    @IBAction func logoutAction(sender: UIButton) {
        
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var LoggedUseUserName = prefs.valueForKey("USERNAME") as! String
        
        let (keychainData, error) = KeyChain.loadDataForUserAccount("\(LoggedUseUserName)")
        var token: AnyObject? = keychainData!["token"] as! String
        
        Alamofire.request(.POST, "http://uatsapp.tk/registerDEV/invalidate.php", parameters: ["invalidator":"\(token!)", "id":"\(loggedUserID)"], encoding: .JSON).responseJSON{
            _, _, JSON, _ in
            let succes:Int = JSON?.valueForKey("succes") as! Int
            let log:String = JSON?.valueForKey("log") as! String
            println("\(succes)","\(log)")
            if succes == 1{
                
                let deleteKeyChain = KeyChain.deleteDataForUserAccount("\(LoggedUseUserName)")
                
                let appDomain = NSBundle.mainBundle().bundleIdentifier
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
                loggedUserID = -1000
            }
        }
        
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