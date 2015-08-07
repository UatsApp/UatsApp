//
//  FriendList.swift
//  UatsApp
//
//  Created by Student on 03/08/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import Foundation

class FriendLIST:NSObject{
    var id_c:Int = 0
    var friendUsername:String = ""
    init(id_c: Int, friendUsername: String){
        self.id_c = id_c;
        self.friendUsername = friendUsername;
    }
}