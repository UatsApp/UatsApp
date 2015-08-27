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
        var (KeyChainData, error) = KeyChain.loadDataForUserAccount("profileIMG")
        
        if let imagePath = KeyChainData!["userImage"] as? String{
            return imagePath
        }else{
            return ""
        }
    }
}


var token: String {
    get {
        var (KeyChainData, error) = KeyChain.loadDataForUserAccount("\(myUserName)")
        
        if let tokenString = KeyChainData!["token"] as? String {
            println("Tokenul sessiunii este: \(tokenString)")
            return tokenString
        } else {
            println("nu exista token")
            return "OMG"
        }
    }
}

var userID: Int {
get {
    var (KeyChainData, error) = KeyChain.loadDataForUserAccount("\(myUserName)")
    
    if let IDString = KeyChainData!["user_id"] as? String{
        let userID:Int? = NSNumberFormatter().numberFromString(IDString)?.integerValue
        println("Id-ul Sessiunii este: \(userID!)")
        return userID!
    }else{
        println("Nu exista USERID IN KeyChain")
        return 0
    }
  }
}