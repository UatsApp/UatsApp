//
//  socketMagager.swift
//  UatsApp
//
//  Created by test on 28/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import Starscream
import Alamofire
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

protocol ReceivedMessageDelegate : NSObjectProtocol {
    func didReceiveMessage(socket : socketManager, message : String)
    func didCancel()
    
}



class socketManager: WebSocketDelegate {
    var socket : WebSocket
    static let sharedSocket = socketManager()
    
    
    //Delegate part
    var delegate : ReceivedMessageDelegate?
    
    func ReceivedMessage(message: String){
        self.delegate?.didReceiveMessage(self, message: message)
        
    }
    
    func cancel(){
        self.delegate?.didCancel()
    }
    
    
    
    
    init(){
        self.socket = WebSocket(url: NSURL(scheme: "ws", host: "46.101.248.188:9400", path: "/")!, protocols: [""])
        socket.delegate = self
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        println("websocket is connected")
        println("{\"type\":\"handShake\", \"senderID\":\"\(loggedUserID)\"}")
        self.socket.writeString("{\"type\":\"handShake\", \"senderID\":\"\(loggedUserID)\"}")
        //send id to sv
        
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("websocket is disconnected: \(e.localizedDescription)")
        } else {
            println("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        println("Received text: \(text)")
        self.ReceivedMessage(text)
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
    }
    
    
}
