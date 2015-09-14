//
//  ChatViewController.swift
//  UatsApp
//
//  Created by Student on 15/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

//var FriendshipINFO:[FriendLIST] = []

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReceivedMessageDelegate {
    
    var user: String!
    var history:[History] = []
    var userInfo:NSArray = []
    var cellMetas:[CellMeta] = []
    var relation_id : Int = 0
    var partener_id : Int = 0
    var partenerName : String = ""
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    let cellHistory = "cell_message"
    let cellInfo = "cell_info"
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraintSendButton: NSLayoutConstraint!
    @IBOutlet var historyTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.sharedSocket.delegate = self
        self.partener_id = userInfo[0] as! Int
        self.partenerName = self.userInfo[1] as! String
        
        historyTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userInfo[1] as? String
        historyTable.delegate = self
        historyTable.dataSource = self
        print(userInfo[1])
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        self.checkRelation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /////Cell construct///////
    struct CellMeta {
        var alingment: NSTextAlignment
        var identifier: String
        var text: String
        
        init(_ alingment: NSTextAlignment, _ identifier: String, _ text: String){
            self.alingment = alingment
            self.identifier = identifier
            self.text = text
        }
        
    }
    
    //Delegate part
    func didReceiveMessage(socket : socketManager ,message: String){
        //Parse received JSON(message)
        let data = message.dataUsingEncoding(NSUTF16StringEncoding, allowLossyConversion: false)
        var localError: NSError?
        var json: AnyObject!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            localError = error
            json = nil
        }
        if let dict = json as? [String: AnyObject] {
            print(dict["message"] as! String)
            let textMessage : String = dict["message"] as! String
            var relID : Int = dict["relation_id"] as! Int
            let senderID : Int = dict["senderID"] as! Int
            let receiverID : Int = dict["receiverID"] as! Int
            let sender_username : String = dict["sender_username"] as! String
            
            if receiverID == userID && senderID == self.partener_id{
                
                let infoMetas = self.cellMetas.filter{$0.identifier == "cell_info"}
                
                if infoMetas.count == 0 || infoMetas.last!.text != sender_username {
                    self.cellMetas.append(CellMeta(NSTextAlignment.Left, "cell_info", sender_username))
                }
                self.cellMetas.append(CellMeta(NSTextAlignment.Left, "cell_message", textMessage))
                
                
                
                
                if self.cellMetas.count >= 0{
                    
                    let delay = 0.1 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.historyTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.cellMetas.count-1 , inSection: 0), atScrollPosition: .Bottom, animated: false)
                    })}
                self.historyTable.reloadData()
            }
        }
    }
    
    func didCancel(){
        print("cenceled")
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject!) {
        
        if messageField.text != ""{
            var messageToSend = messageField.text
            socketManager.sharedSocket.socket.writeString("{\"type\":\"msg\", \"message\":\"\(messageToSend)\", \"relation_id\":\(self.relation_id), \"senderID\":\(userID), \"receiverID\":\(self.partener_id), \"sender_username\":\"\(myUserName)\"}")
            
            Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/insert_message.php", parameters: ["message" : "\(messageToSend)" , "relation_id"  : "\(self.relation_id)" , "senderID" : "\(userID)", "token":"\(token)"], encoding: .JSON).responseJSON {
                _, _, JSON, _ in
                //TODO check the result from insert_message.php which is ???"string"???
            }
            
            
            let infoMetas = self.cellMetas.filter{$0.identifier == "cell_info"}
            
            if infoMetas.count == 0 || infoMetas.last!.text != myUserName {
                self.cellMetas.append(CellMeta(NSTextAlignment.Right, "cell_info", myUserName))
            }
            self.cellMetas.append(CellMeta(NSTextAlignment.Right, "cell_message", messageToSend))
            
            if self.cellMetas.count >= 0{
                
                let delay = 0.1 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.historyTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.cellMetas.count-1 , inSection: 0), atScrollPosition: .Bottom, animated: false)
                })}
            
            self.historyTable.reloadData()
            messageField.text  = ""
            
        }
        
    }
    
    
    ////////////////Constraint TextField To Keyboard////////////////////
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
        
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    func dismissKeyboard(sender: AnyObject) {
        messageField?.resignFirstResponder()
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        bottomLayoutConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
        bottomLayoutConstraintSendButton.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
        if self.cellMetas.count > 0{
            let delay = 0.1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(time, dispatch_get_main_queue(), {
                self.historyTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.cellMetas.count-1 , inSection: 0), atScrollPosition: .Bottom, animated: false)
            })}
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState.union(animationCurve), animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //////Populate Class History, populate cells/////////////////
    func checkRelation(){
        //Get History
        Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/history.php", parameters: ["identifier": "\(userInfo[0])" , "loggedUsername":"\(myUserName)", "token":"\(token)", "uid":"\(userID)"], encoding: .JSON)
            .responseJSON { _, _, JSON, _ in
                var status = JSON?.valueForKey("status") as! Int
                self.relation_id = JSON?.valueForKey("relation_id") as! Int
                if let jsonResult = JSON?.valueForKey("history") as? Array<Dictionary<String,String>>{
                    var i = 0
                    self.history = []
                    self.cellMetas = []
                    for (i = 0; i < jsonResult.count; i++)
                    {
                        let from = jsonResult[i]["_from"]
                        let to = jsonResult[i]["_to"]
                        let message = jsonResult[i]["message"]
                        let time = jsonResult[i]["_time"]
                        
                        var currentHistory = History(id_c: self.relation_id, _from: Int(from!)!, _to: Int(to!)!, message: message!, _time: time!);
                        
                        self.history.append(currentHistory);
                        
                    }
                }
                print(JSON) //History JSON
                if self.history.count > 0 {
                    
                    let partnerUserName = self.userInfo[1] as! String
                    var currentFromUserId = -1000
                    
                    // var currINFO = FriendLIST(id_c: self.relation_id, friendUsername: partnerUserName)
                    // FriendshipINFO.append(currINFO)
                    
                    for historyItem in self.history {
                        
                        if historyItem._from != currentFromUserId {
                            currentFromUserId = historyItem._from
                            self.cellMetas.append(CellMeta( self.partener_id == currentFromUserId ? NSTextAlignment.Left : NSTextAlignment.Right, "cell_info", self.partener_id == currentFromUserId ? self.partenerName  : myUserName))
                        }
                        
                        self.cellMetas.append(CellMeta( self.partener_id == historyItem._from ? NSTextAlignment.Left : NSTextAlignment.Right, "cell_message", historyItem.message))
                        
                    }
                }
                //////////////Autoscroll to last Message///////////////
                if self.cellMetas.count > 0{
                    let delay = 0.1 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.historyTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.cellMetas.count-1 , inSection: 0), atScrollPosition: .Bottom, animated: false)
                    })}
                
                self.historyTable.reloadData()
        }
        
    }
    
    /////////Table View Implement////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellMetas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let meta = cellMetas[indexPath.row]
        if meta.identifier == "cell_info" {
            return 20
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meta = cellMetas[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(meta.identifier, forIndexPath: indexPath) 
        
        cell.textLabel?.text = meta.text
        cell.textLabel?.textAlignment = meta.alingment
        
        return cell
    }
}

extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendButtonTapped(nil)
        return true
    }
}