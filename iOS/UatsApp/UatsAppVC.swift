//
//  UatsAppVC.swift
//  UatsApp
//
//  Created by Student on 10/06/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit

class UatsAppVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logout.layer.cornerRadius = 5.0
        self.logout.layer.borderColor = UIColor.whiteColor().CGColor
        self.logout.layer.borderWidth = 0.2

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var txtusername: UILabel!

    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var `continue`: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedin:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if(isLoggedin != 1){
            self.performSegueWithIdentifier("goApp", sender: self)
        }
        else{
            self.txtusername.text = prefs.valueForKey("USERNAME") as? String
        }
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    @IBAction func continueTapped(sender: UIButton) {
        self.performSegueWithIdentifier("goInapp", sender: self)
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
