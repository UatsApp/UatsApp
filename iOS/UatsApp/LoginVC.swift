//
//  LoginVC.swift
//  UatsApp
//
//  Created by Student on 10/06/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire


class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var FBButton: FBSDKLoginButton!
    
    var DataForAutoComplete:NSArray = []
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBButton.delegate = self
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        self.FBButton.layer.cornerRadius = 15.0
        self.signin.layer.cornerRadius = 5.0
        self.signin.layer.borderColor = UIColor.whiteColor().CGColor
        self.signin.layer.borderWidth = 0.2
        if DataForAutoComplete.count != 0 {
            self.txtUsername.text = DataForAutoComplete[0] as? String
            self.txtPassword.text = DataForAutoComplete[1] as? String
        }
        
        //try! KeyChain.updateData(["enroll":"3"], forUserAccount: "enroll")
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedin:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        print(enrollStep)
        
        if(isLoggedin == 1 && enrollStep == 4){
            self.performSegueWithIdentifier("goApp", sender: self)//////////DE PUS LOGOUT IN APP SI SCBHIMBAT '!=' IN '==';////////////////
        }else if(enrollStep == 1){
            self.performSegueWithIdentifier("gotoEnroll", sender: self)
        }else if(enrollStep == 2){
            self.performSegueWithIdentifier("gotoEnroll2", sender: self)
        }else if(enrollStep == 3){
            self.performSegueWithIdentifier("gotoEnroll3", sender: self)
        }
        
        //FB login
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            
            // User is already logged in, do work such as go to next view controller.
            
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            // self.view.addSubview(loginView)
            //loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
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
        txtUsername?.resignFirstResponder()
        txtPassword?.resignFirstResponder()
    }
    
    func loginButton(FBButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(FBButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched facebook user: \(result)")
                // TODO skip enroll steps, register with fb credentials and profile image.
                //                let userName : NSString = result.valueForKey("name") as! NSString
                //                println("User name is: \(userName)")
                //                let userEmail : NSString = result.valueForKey("email") as! NSString
                //                println("User Email is: \(userEmail)")
                //                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                //                prefs.setObject(userName, forKey: "USERNAME")
                
            }
        })
    }
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    @IBOutlet weak var signin: UIButton!
    
    @IBAction func signinTapped(sender: AnyObject?) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            //var post:NSString = "username=\(username)&password=\(password)"
            let post:String = "{\"username\":\"\(username)\",\"password\":\"\(password)\",\"type\":\"simpleLogin\"}"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "http://uatsapp.tk/UatsAppWebDEV/process.php")!
            
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var _: NSError?
                    
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                    
                    
                    let status:NSInteger = jsonData.valueForKey("status") as! NSInteger
                    
                    NSLog("Success: %ld", status);
                    
                    if(status == 1)
                    {
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        let user_id:Int = jsonData.valueForKey("user_id") as! Int
                        let SessionToken:String = jsonData.valueForKey("token") as! String
                        try! KeyChain.saveData(["token" : "\(SessionToken)","user_id":"\(user_id)"], forUserAccount: "\(username)")
                        
                        NSLog("Login SUCCESS");
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Success!"
                        alertView.message = "You are logged in!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        if enrollStep == 1{
                            self.performSegueWithIdentifier("gotoEnroll", sender: self)
                        } else{
                            self.performSegueWithIdentifier("goApp", sender: self)
                        }
                        //  self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error"] as? NSString != nil {
                            error_msg = jsonData["error"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
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

extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == txtUsername){
            txtPassword.becomeFirstResponder()
        }else{
            signinTapped(nil)
        }
        return true
    }
}