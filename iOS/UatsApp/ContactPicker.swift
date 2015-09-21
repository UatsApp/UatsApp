//
//  ContactPicker.swift
//  UatsApp
//
//  Created by Student on 21/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit

class ContactPicker: UIViewController {

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
        self.performSegueWithIdentifier("goinApp", sender: self)
        try! KeyChain.updateData(["enroll":"4"], forUserAccount: "enroll")
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
