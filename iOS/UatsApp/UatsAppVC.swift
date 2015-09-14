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
        socketManager.sharedSocket.socket.connect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = myUserName
    }
    
    @IBOutlet var logoutBtn: UIButton!
    @IBAction func logoutAction(sender: UIButton) {
        
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
//        Alamofire.request(.POST, "http://uatsapp.tk/registerDEV/invalidate.php", parameters: ["invalidator":"\(token)", "id":"\(userID)"], encoding: .JSON)
//            .responseJSON { _, _, JSON in
//                
//            let status:Int = JSON.value!["status"] as! Int
//            let log:String = JSON.valueForKey("log") as! String
//            print("\(status)","\(log)")
//            let deleteKeyChain = try KeyChain.deleteDataForUserAccount("\(myUserName)")
//            if status == 1{
//                socketManager.sharedSocket.socket.disconnect()
//                let deleteKeyChain = KeyChain.deleteDataForUserAccount("\(myUserName)")
//                
//                let appDomain = NSBundle.mainBundle().bundleIdentifier
//                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
//            }
//                print(JSON)
//        }
        
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