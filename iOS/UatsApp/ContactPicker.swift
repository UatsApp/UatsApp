//
//  ContactPicker.swift
//  UatsApp
//
//  Created by Student on 21/09/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit
import AddressBook

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

    @IBAction func continueButtonTapped(sender: AnyObject) {
        //self.performSegueWithIdentifier("goinApp", sender: self)
        //try! KeyChain.updateData(["enroll":"4"], forUserAccount: "enroll")
        getAddressBookNames()
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
