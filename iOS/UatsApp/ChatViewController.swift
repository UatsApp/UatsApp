//
//  ChatViewController.swift
//  UatsApp
//
//  Created by Student on 15/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReceivedMessageDelegate {
    
    /////Cell construct///////
    var relation_id : Int = 0
    var partener_id : Int = 0
    var myUserName : String = ""
    var partenerName : String = ""
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
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
        var data = message.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
        var localError: NSError?
        var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &localError)
        if let dict = json as? [String: AnyObject] {
            println(dict["message"] as! String)
            var MsgToSend : String = dict["message"] as! String
            var RelToSend : Int = dict["relation_id"] as! Int
            var SenderToSend : Int = dict["senderID"] as! Int
            
            
            //Validate message
            Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/validate_message.php", parameters: ["message" : "\(MsgToSend)" , "senderID" : "\(SenderToSend)", "relation_id"  : "\(RelToSend)"], encoding: .JSON).responseJSON {
                _, _, JSON, _ in
                println(JSON)
                if let jsonResponse = JSON as? [String : AnyObject]{
                    println(jsonResponse["sender"])
                    
                    if jsonResponse["receiver"] as! Int == loggedUserID && jsonResponse["sender"] as! Int == self.partener_id{
                        
                        
                        let infoMetas = self.cellMetas.filter{$0.identifier == "cell_info"}
                        
                        if infoMetas.count == 0 || infoMetas.last!.text != jsonResponse["sender_username"] as! String {
                            self.cellMetas.append(CellMeta(NSTextAlignment.Left, "cell_info", jsonResponse["sender_username"] as! String))
                        }
                        self.cellMetas.append(CellMeta(NSTextAlignment.Left, "cell_message", jsonResponse["message"] as! String))
                        
                        
                        
                        
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
            
            
        }
        
        
    }
    
    func didCancel(){
        println("cenceled")
    }
    
    
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraintSendButton: NSLayoutConstraint!
    
    
    
    @IBOutlet var historyTable: UITableView!
    let cellHistory = "cell_message"
    let cellInfo = "cell_info"
    var user: String!
    var history:[History] = []
    var userInfo:NSArray = []
    var cellMetas:[CellMeta] = []
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.sharedSocket.delegate = self
        self.partener_id = userInfo[0] as! Int
        self.partenerName = self.userInfo[1] as! String
        
        historyTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendButtonTapped(sender: AnyObject!) {
        if messageField.text != ""{
            var messageToSend = messageField.text
            socketManager.sharedSocket.socket.writeString("{\"message\":\"\(messageToSend)\",\"relation_id\":\"\(self.relation_id)\",\"senderID\":\"\(loggedUserID)\"}")
            
            Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/insert_message.php", parameters: ["message" : "\(messageToSend)" , "relation_id"  : "\(self.relation_id)" , "senderID" : "\(loggedUserID)"], encoding: .JSON).responseJSON {
                _, _, JSON, _ in
                //TODO check the result from insert_message.php which is ???"string"???
            }
            
            
            let infoMetas = self.cellMetas.filter{$0.identifier == "cell_info"}
            
            if infoMetas.count == 0 || infoMetas.last!.text != self.myUserName {
                self.cellMetas.append(CellMeta(NSTextAlignment.Right, "cell_info", self.myUserName))
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userInfo[1] as? String
        historyTable.delegate = self
        historyTable.dataSource = self
        println(userInfo[1])
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
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    //////Populate Class History, populate cells/////////////////
    func checkRelation(){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.myUserName  = prefs.valueForKey("USERNAME") as! String
        //Get History
        Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/history.php", parameters: ["identifier": "\(userInfo[0])" , "loggedUsername":"\(self.myUserName)"], encoding: .JSON)
            .responseJSON { _, _, JSON, _ in
                self.relation_id = JSON?.valueForKey("relation_id") as! Int
                loggedUserID = JSON?.valueForKey("loggedUserID") as! Int
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
                        
                        var currentHistory = History(id_c: self.relation_id, _from: from!.toInt()!, _to: to!.toInt()!, message: message!, _time: time!);
                        
                        self.history.append(currentHistory);
                        
                    }
                }
                println(JSON) //History JSON
                if self.history.count > 0 {
                    
                    
                    let partnerUserName = self.userInfo[1] as! String
                    
                    var currentFromUserId = -1000
                    
                    for historyItem in self.history {
                        
                        if historyItem._from != currentFromUserId {
                            currentFromUserId = historyItem._from
                            self.cellMetas.append(CellMeta( self.partener_id == currentFromUserId ? NSTextAlignment.Left : NSTextAlignment.Right, "cell_info", self.partener_id == currentFromUserId ? self.partenerName  : self.myUserName))
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(meta.identifier, forIndexPath: indexPath) as! UITableViewCell
        
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
