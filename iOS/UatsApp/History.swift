//
//  History.swift
//  UatsApp
//
//  Created by Student on 20/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import Foundation

class History:NSObject{
    var id_c:Int = 0
    var _from:Int = 0
    var _to:Int = 0
    var message:String!
    var _time:String!
    
    init(id_c: Int, _from: Int, _to: Int,message: String, _time: String){
        self.id_c = id_c;
        self._from = _from;
        self._to = _to;
        self.message = message;
        self._time = _time;
        
    }
}