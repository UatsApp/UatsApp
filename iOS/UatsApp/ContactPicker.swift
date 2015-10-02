//
//  ContactPicker.swift
//  UatsApp
//
//  Created by Student on 21/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit
import AddressBook

class ContactPicker: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var contactList: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var contacts = [String]()
    var checked = [Bool]()
    
    var cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactList.delegate = self
        contactList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getAddressBookNames()
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
        while(checked.count != contacts.count)
        {
            checked.append(false)
        }
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contactList.dequeueReusableCellWithIdentifier("cellIdentifier")
        print("-----------------------------------\(contacts)---------------------------------")
        
        if checked[indexPath.row] == false {
            
            cell!.accessoryType = .None
        }
        else if checked[indexPath.row] == true {
            
            cell!.accessoryType = .Checkmark
        }
        cell!.textLabel?.text = contacts[indexPath.row]
        self.contactList.tableFooterView = UIView(frame: CGRectZero)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        contactList.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
                checked[indexPath.row] = false
            }
            else
            {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
        }
    }
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        //        self.performSegueWithIdentifier("goinApp", sender: self)
        //        try! KeyChain.updateData(["enroll":"4"], forUserAccount: "enroll")
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