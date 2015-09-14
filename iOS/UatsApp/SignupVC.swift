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
    @IBOutlet weak var txtNickName: UITextField!
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signup.layer.cornerRadius = 5.0
        self.signup.layer.borderColor = UIColor.whiteColor().CGColor
        self.signup.layer.borderWidth = 0.2
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        self.txtConfrimPassword.delegate = self
        self.txtEmail.delegate = self
        self.txtNickName.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        txtEmail?.resignFirstResponder()
        txtPassword?.resignFirstResponder()
        txtUsername?.resignFirstResponder()
        txtConfrimPassword?.resignFirstResponder()
        txtNickName?.resignFirstResponder()
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return  !result

        
    }
    
    
    
    @IBOutlet weak var signup: UIButton!
    

    @IBAction func singupTapped(sender: AnyObject!){
        let username:NSString = txtUsername.text as NSString
        let password:NSString = txtPassword.text as NSString
        let comfirm_password:String = txtConfrimPassword.text as String
        let email:String = txtEmail.text as String
        let nickname:String = txtNickName.text as String
        
        
        if(username.isEqualToString("") || password.isEqualToString(""))
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Please enter username and password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else if (!password.isEqual(comfirm_password)){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Passwords don't match!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else if (isValidEmail(txtEmail.text)){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Invalid email!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }else {
            //var post:NSString = "username=\(username)&password=\(password)&c_password=\(comfirm_password)&email=\(email)"
            let post:String = "{\"username\":\"\(username)\",\"password\":\"\(password)\",\"c_password\":\"\(comfirm_password)\",\"email\":\"\(email)\",\"nickname\":\"\(nickname)\"}"
            NSLog("Post data: %@",post);
            
            let url:NSURL = NSURL(string: "http://uatsapp.tk/registerDEV/jsonsignup.php")!
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength:NSString = String(postData.length)
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            request.HTTPMethod = ("POST")
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField:"Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response:NSURLResponse?
            var urlData:NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            } catch let error as NSError {
                responseError = error
                urlData = nil
            }
            if(urlData != nil){
                let res = response as! NSHTTPURLResponse!;
                NSLog("Response code: %ld", res.statusCode)
                if(res.statusCode >= 200 && res.statusCode < 300){
                    let responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    var error:NSError?
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    NSLog("Success %ld", success);
                    
                    if(success == 1){
                        NSLog("Sign Up Success");
                        let alertView:UIAlertView = UIAlertView()
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
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }else{
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Faile!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }else{
                let alertView:UIAlertView = UIAlertView()
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

extension SignupVC:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == txtUsername){
            txtPassword.becomeFirstResponder()
        }else if(textField == txtPassword){
            txtConfrimPassword.becomeFirstResponder()
        }else if (textField == txtConfrimPassword){
            txtEmail.becomeFirstResponder()
        }else if(textField == txtEmail){
            txtNickName.becomeFirstResponder()
        }else{
            singupTapped(nil)
        }
        return true
    }
}
