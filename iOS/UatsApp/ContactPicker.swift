//
//  ContactPicker.swift
//  UatsApp
//
//  Created by Student on 21/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit
import AddressBook
import Alamofire
var friendsToInvite = [String]()


class ContactPicker: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var contactList: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var addEmailAdress: UIButton!
    
    
    var contacts = [String]()
    var checked = [Bool]()
    var existingFriends:Array<String> = []
    var cellIdentifier = "cellIdentifier"
    var userEmailInput:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactList.delegate = self
        contactList.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        contactList.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    func hideKeyboard() {
        contactList.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getAddressBookNames()
        if (contacts.count > 0){
            self.checkExistingFriends()
        }
        self.contactList.reloadData()
    }
    
    func getAddressBookNames() {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        if (authorizationStatus == ABAuthorizationStatus.NotDetermined)
        {
            NSLog("requesting access...")
            let addressBook = !(ABAddressBookCreateWithOptions(nil, nil) != nil)
            ABAddressBookRequestAccessWithCompletion(addressBook,{success, error in
                if success {
                    self.processContactNames();
                }
                else {
                    NSLog("unable to request access")
                }
            })
        }
        else if (authorizationStatus == ABAuthorizationStatus.Denied || authorizationStatus == ABAuthorizationStatus.Restricted) {
            NSLog("access denied")
        }
        else if (authorizationStatus == ABAuthorizationStatus.Authorized) {
            NSLog("access granted")
            processContactNames()
        }
    }
    
    func processContactNames()
    {
        var errorRef: Unmanaged<CFError>?
        let addressBook: ABAddressBookRef? = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        
        let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        print("records in the array \(contactList.count)")
        for record:ABRecordRef in contactList {
            processAddressbookRecord(record)
        }
    }
    
    func processAddressbookRecord(addressBookRecord: ABRecordRef) {
        let contactName: String = ABRecordCopyCompositeName(addressBookRecord).takeRetainedValue() as NSString as String
        NSLog("contactName: \(contactName)")
        processEmail(addressBookRecord)
    }
    
    func processEmail(addressBookRecord: ABRecordRef) {
        let emailArray:ABMultiValueRef = extractABEmailRef(ABRecordCopyValue(addressBookRecord, kABPersonEmailProperty))!
        for (var j = 0; j < ABMultiValueGetCount(emailArray); ++j) {
            let emailAdd = ABMultiValueCopyValueAtIndex(emailArray, j)
            let myString = extractABEmailAddress(emailAdd)
            contacts.append(myString!)
            self.contactList.reloadData()
            NSLog("email: \(myString!)")
        }
    }
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func extractABEmailRef (abEmailRef: Unmanaged<ABMultiValueRef>!) -> ABMultiValueRef? {
        if let ab = abEmailRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func extractABEmailAddress (abEmailAddress: Unmanaged<AnyObject>!) -> String? {
        if let _ = abEmailAddress {
            return Unmanaged.fromOpaque(abEmailAddress.toOpaque()).takeUnretainedValue() as CFStringRef as String
        }
        return nil
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if existingFriends.count > 0{
            while(checked.count != existingFriends.count)
            {
                checked.append(false)
            }
            print("Prietenii de pe server:\(existingFriends.count)")
            return existingFriends.count
        }else{
            return userEmailInput
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contactList.dequeueReusableCellWithIdentifier("cellIdentifier") as! TextInputTableViewCell
        print("-----------------------------------\(existingFriends)---------------------------------")
        if existingFriends.count > 0{
            
            if checked[indexPath.row] == false {
                
                cell.accessoryType = .None
            }
            else if checked[indexPath.row] == true {
                
                cell.accessoryType = .Checkmark
            }
            addEmailAdress.hidden = true
            cell.textLabel?.text = existingFriends[indexPath.row]
            cell.emailTextField.hidden = true
        }else{
            if friendsToInvite.count == 0{
                cell.configure("", placeholder: "Email adress")
            }else{
                cell.textLabel?.text = friendsToInvite[indexPath.row]
            }
        }
        //cell.emailTextField.delegate = self
        self.contactList.tableFooterView = UIView(frame: CGRectZero)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        contactList.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if existingFriends.count > 0{
                if cell.accessoryType == .Checkmark
                {
                    friendsToInvite.removeAtIndex(indexPath.row)
                    cell.accessoryType = .None
                    checked[indexPath.row] = false
                }
                else
                {
                    friendsToInvite.append(existingFriends[indexPath.row])
                    cell.accessoryType = .Checkmark
                    checked[indexPath.row] = true
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        if testStr.isEmpty{
            return false
        }else{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
            let result = range != nil ? true : false
            return  !result
        }
    }
    
    func checkExistingFriends(){
        
        let parameters =  ["friends": contacts, "token":"\(token)", "uid":"\(userID)"]
        NSLog("JSON to send: \(parameters)")
        
        Alamofire.request(.POST, "http://uatsapp.tk/accounts/friendInvites.php", parameters: parameters as? [String : AnyObject], encoding: .JSON) .responseJSON {
            _, _, result in
            switch result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                if let success = result.value!["success"] as? Array<Dictionary<String,String>>{
                    var i = 0
                    for (i = 0; i < success.count; i++){
                        let email = success[i]["email"]
                        self.existingFriends.append(email!)
                        NSLog("\(self.existingFriends)")
                        self.contactList.reloadData()
                    }
                }
            case .Failure(let data, let error):
                print("Request failed with error: \(error)")
                
                if let data = data {
                    print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                }
            }
        }
    }
    
    @IBAction func addEmailAdressTapped(sender: AnyObject) {
        if friendsToInvite.count == 0 {
            let alertView:UIAlertView = UIAlertView(title: "Oops!", message: "Add an Email adress first", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }else{
            userEmailInput = userEmailInput + 1
            friendsToInvite.append("")
            self.contactList.reloadData()
        }
    }
    
    @IBAction func continueButtonTapped(sender: AnyObject!) {
        //        let parameters = ["friends": friendsToInvite]
        //self.performSegueWithIdentifier("goinApp", sender: self)
        //try! KeyChain.updateData(["enroll":"4"], forUserAccount: "enroll")
        print("------------------friends to invite:\(friendsToInvite)----------------------")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if isValidEmail(textField.text!){
            let alertView:UIAlertView = UIAlertView(title: "Oops!", message: "Add a valid Email adress\n\"\(textField.text!)\" is not a valid email adress!", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }else{
            friendsToInvite.append(textField.text!)
            continueButtonTapped(nil)
            hideKeyboard()
        }
        return true
    }
    var adbk : ABAddressBook!
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}