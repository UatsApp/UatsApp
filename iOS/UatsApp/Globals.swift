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
        
        if let imagePath = KeyChainData!["userImage"]{
            return imagePath as! String
        }else{
            return ""
        }
    }
}


var token: String {
    get {
        var KeyChainData = KeyChain.loadDataForUserAccount("\(myUserName)")
        
        if let tokenString = KeyChainData!["token"] {
            print("Tokenul sessiunii este: \(tokenString)")
            return tokenString as! String
        } else {
            print("nu exista token")
            return "OMG"
        }
    }
}

var userID: Int {
get {
    let KeyChainData = KeyChain.loadDataForUserAccount("\(myUserName)")
    
    if let IDString = KeyChainData!["user_id"]{
        let userID:Int? = NSNumberFormatter().numberFromString(IDString as! String)?.integerValue
        print("Id-ul Sessiunii este: \(userID!)")
        return userID!
    }else{
        print("Nu exista USERID IN KeyChain")
        return 0
    }
  }
}