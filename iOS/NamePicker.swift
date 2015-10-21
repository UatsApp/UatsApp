//
//  namePicker.swift
//  UatsApp
//
//  Created by Student on 17/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class namePicker: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var nickNameTxt: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullNameTxt.delegate = self
        self.nickNameTxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        nickNameTxt?.resignFirstResponder()
        fullNameTxt?.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func continueButtonTapped(sender: AnyObject?) {
        let fullname:String = fullNameTxt.text!
        let nickname:String = nickNameTxt.text!
        if (fullname.isEmpty){
            let alertView:UIAlertView = UIAlertView(title: "Info!", message: "Please enter your full name", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }else if(nickname.isEmpty){
            let alertView:UIAlertView = UIAlertView(title: "Info!", message: "Please enter an Nickname", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }else{
            Alamofire.request(.POST, "http://uatsapp.tk/registerDEV/enrollProcess.php", parameters: ["token":"\(token)", "id":"\(userID)", "enrollStep": "2", "name":"\(fullname)", "nickname":"\(nickname)"], encoding: .JSON) .responseJSON {
                _, _, JSON in
                
                let status = JSON.value!["status"] as! Int
                let log = JSON.value!["log"] as! String
                
                if status == 1{
                    self.performSegueWithIdentifier("enrollment3", sender: self)
                    try! KeyChain.updateData(["enroll":"3"], forUserAccount: "enroll")
                }else{
                    print(log)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == fullNameTxt){
            nickNameTxt.becomeFirstResponder()
        }else{
            continueButtonTapped(nil)
        }
        return true
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
