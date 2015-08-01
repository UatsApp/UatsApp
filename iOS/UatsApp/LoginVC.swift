//
//  LoginVC.swift
//  UatsApp
//
//  Created by Student on 10/06/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

var loggedUserID : Int = -1000

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var DataForAutoComplete:NSArray = []
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signin.layer.cornerRadius = 15.0
        self.signin.layer.borderColor = UIColor.whiteColor().CGColor
        self.signin.layer.borderWidth = 0.2
        
        if DataForAutoComplete.count != 0 {
            self.txtUsername.text = DataForAutoComplete[0] as! String
            self.txtPassword.text = DataForAutoComplete[1] as! String
        }
        
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedin:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        let isFacebookLoggedIn :Int = prefs.integerForKey("ISFACEBOOKLOGGED") as Int
        
        if(isLoggedin == 1 || isFacebookLoggedIn == 1){
            self.performSegueWithIdentifier("goApp", sender: self)//////////DE PUS LOGOUT IN APP SI SCBHIMBAT '!=' IN '==';////////////////
          
        }
        
        //FB login
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            
            // User is already logged in, do work such as go to next view controller.
            
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
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
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
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
              self.checkFacebookUser()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched facebook user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                println("User name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                println("User Email is: \(userEmail)")
//                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//                prefs.setObject(userName, forKey: "USERNAME")
                
            }
        })
    }
    
    func checkFacebookUser(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched facebook user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                let userEmail : String = result.valueForKey("email") as! String
                
                
                //Validate  Facebook User
                Alamofire.request(.POST, "http://uatsapp.tk/registerDEV/jsonsignup.php", parameters: ["username": "\(userName)", "password" : "\(userName)", "c_password": "\(userName)", "email" : "\(userEmail)"], encoding: .JSON)
                    .responseJSON { _, _, JSON, _ in
                        println(JSON)
                        let jsonResult = JSON?.valueForKey("success") as? Int
                        if((jsonResult) != nil){
                            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(1, forKey: "ISFACEBOOKLOGGED")
                            if JSON?.valueForKey("FBUserID") != nil {
                                loggedUserID = (JSON?.valueForKey("FBUserID") as? Int)!
                            }
                            
                            self.performSegueWithIdentifier("goApp", sender: self)
                            
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Success!"
                            alertView.message = "You are logged in!"
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                        }
                        
                        

                        
                }

                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject(userName, forKey: "USERNAME")
                
            }
        })
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
    @IBOutlet weak var signin: UIButton!
    
    @IBAction func signinTapped(sender: UIButton) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            
            //var post:NSString = "username=\(username)&password=\(password)"
            var post:String = "{\"username\":\"\(username)\",\"password\":\"\(password)\"}"
            
            NSLog("PostData: %@",post);
            
            // var url:NSURL = NSURL(string: "http://uatsapp.16mb.com/register/jsonlogin2.php")!
            // var url:NSURL = NSURL(string: "http://uatsapp.tk/registerDEV/jsonlogin1.php")!
            var url:NSURL = NSURL(string: "http://uatsapp.tk/UatsAppWebDEV/process_user.php")!
            
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    
                    let status:NSInteger = jsonData.valueForKey("status") as! NSInteger
                    let user_id:NSInteger = jsonData.valueForKey("user_id") as! NSInteger
                    loggedUserID = user_id
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", status);
                    
                    if(status == 1)
                    {
                        NSLog("Login SUCCESS");
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Success!"
                        alertView.message = "You are logged in!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        self.performSegueWithIdentifier("goApp", sender: self)
                        
                        //  self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error"] as? NSString != nil {
                            error_msg = jsonData["error"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
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
