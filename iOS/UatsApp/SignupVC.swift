//
//  SignupVC.swift
//  UatsApp
//
//  Created by Student on 10/06/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signup.layer.cornerRadius = 5.0
        self.signup.layer.borderColor = UIColor.whiteColor().CGColor
        self.signup.layer.borderWidth = 0.2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        println("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return  !result

        
    }
    
    
    @IBOutlet weak var signup: UIButton!


    @IBAction func singupTapped(sender: UIButton){
        var username:NSString = txtUsername.text as NSString
        var password:NSString = txtPassword.text as NSString
        var comfirm_password:NSString = txtConfrimPassword.text as NSString
        var email:NSString = txtEmail.text as NSString
        
        if(username.isEqualToString("") || password.isEqualToString(""))
        {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Please enter username and password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else if (!password.isEqual(comfirm_password)){
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Passwords don't match!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else if (isValidEmail(txtEmail.text)){
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Invalid email!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else {
            //var post:NSString = "username=\(username)&password=\(password)&c_password=\(comfirm_password)&email=\(email)"
            var post:String = "{\"username\":\"\(username)\",\"password\":\"\(password)\",\"c_password\":\"\(comfirm_password)\",\"email\":\"\(email)\"}"
            NSLog("Post data: %@",post);
            
            var url:NSURL = NSURL(string: "http://uatsapp.tk/registerDEV/jsonsignup.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String(postData.length)
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            request.HTTPMethod = ("POST")
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField:"Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response:NSURLResponse?
            var urlData:NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            if(urlData != nil){
                let res = response as! NSHTTPURLResponse!;
                NSLog("Response code: %ld", res.statusCode)
                if(res.statusCode >= 200 && res.statusCode < 300){
                    var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    var error:NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    NSLog("Success %ld", success);
                    
                    if(success == 1){
                        NSLog("Sign Up Success");
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Success"
                        alertView.message = "Sign Up Success!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        let data:NSArray = [username, password]
                        self.performSegueWithIdentifier("BackToLogin", sender: data)
                       // self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        var error_msg:NSString
                        if jsonData["error_message"] as? NSString != nil
                        {
                            error_msg = jsonData["error_message"] as! NSString
                        }else{
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }else{
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Faile!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }else{
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Connection Failure"
                if let error = responseError{
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
    }

    

    @IBAction func gotoLogin(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "BackToLogin"{
            let loginController = segue.destinationViewController as! LoginVC
            loginController.DataForAutoComplete = sender as! NSArray
        }
    }
    

}

