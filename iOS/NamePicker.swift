//
//  namePicker.swift
//  UatsApp
//
//  Created by Student on 17/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class namePicker: UIViewController {

    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var nickNameTxt: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        let fullname = fullNameTxt.text!
        let nickname = nickNameTxt.text!
        print(token)
        Alamofire.request(.POST, "http://uatsapp.tk/registerDEV/enrollProcess.php", parameters: ["token":"\(token)", "id":"\(userID)", "enrollStep": "2", "name":"\(fullname)", "nickname":"\(nickname)"], encoding: .JSON) .responseJSON {
            _, _, JSON in
            
            let status = JSON.value!["status"] as! Int
            
            if status == 1{
                self.performSegueWithIdentifier("enrollment3", sender: self)
                try! KeyChain.updateData(["enroll":"3"], forUserAccount: "enroll")
            }else{
//                deleteKeychainAccess()
//                rootVC()
                //TODO GO TO ROOOT VIEW CONTROLLER
            }
        }
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
