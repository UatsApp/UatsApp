//
//  Globals.swift
//  UatsApp
//
//  Created by Student on 17/08/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import Foundation

var myUserName: String{
get {
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    if let myUserName  = prefs.valueForKey("USERNAME") as? String{
        return myUserName
    }else{
        return "Nu exista Username in Preferitne"
    }
}
}

var userAvatar: String{
get{
    let KeyChainData = KeyChain.loadDataForUserAccount("profileIMG")
    
    if KeyChainData != nil{
        let imagePath = KeyChainData!["userImage"]
        //print(imagePath)
        return imagePath as! String
    }else{
        let defaultImageURL = NSBundle.mainBundle().URLForResource("1024x1024", withExtension: "png")
        return defaultImageURL!.path!
    }
}
}


var token: String {
get {
    var KeyChainData = KeyChain.loadDataForUserAccount("\(myUserName)")
    
    if let tokenString = KeyChainData!["token"] {
        NSLog("Tokenul sessiunii este: \(tokenString)")
        return tokenString as! String
    } else {
        NSLog("nu exista token")
        return "OMG"
    }
}
}

var userID: Int {
get {
    let KeyChainData = KeyChain.loadDataForUserAccount("\(myUserName)")
    
    if let IDString = KeyChainData!["user_id"]{
        let userID:Int? = NSNumberFormatter().numberFromString(IDString as! String)?.integerValue
        NSLog("Id-ul Sessiunii este: \(userID!)")
        return userID!
    }else{
        NSLog("Nu exista USERID IN KeyChain")
        return 0
    }
}
}

var enrollStep: Int{
get{
    let KeyChainData = KeyChain.loadDataForUserAccount("enroll")
    if KeyChainData != nil{
        let enrollmentStep = KeyChainData!["enroll"]
        let enroll:Int? = NSNumberFormatter().numberFromString(enrollmentStep as! String)?.integerValue
        return enroll!
    }else{
        NSLog("Oops, Enroll is fucked up!")
        return 0
    }
}
}

func rootVC(){
    UIApplication.sharedApplication().windows[0].rootViewController?.dismissViewControllerAnimated(true, completion: nil)
}

func deleteKeychainAccess(){
    socketManager.sharedSocket.socket.disconnect()
    try! KeyChain.deleteDataForUserAccount("\(myUserName)")
    let appDomain = NSBundle.mainBundle().bundleIdentifier
    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
}