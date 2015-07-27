//
//  ChatViewController.swift
//  UatsApp
//
//  Created by Student on 15/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        historyTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
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
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
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
        var userUsername = prefs.valueForKey("USERNAME") as! String
        Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/history.php", parameters: ["identifier": "\(userInfo[0])" , "loggedUsername":"\(userUsername)"], encoding: .JSON)
            .responseJSON { _, _, JSON, _ in
                if let jsonResult = JSON?.valueForKey("history") as? Array<Dictionary<String,String>>{
                    var i = 0
                    self.history = []
                    self.cellMetas = []
                    for (i = 0; i < jsonResult.count; i++)
                    {
                        
                        let relID = jsonResult[i]["id_c"]
                        let from = jsonResult[i]["_from"]
                        let to = jsonResult[i]["_to"]
                        let message = jsonResult[i]["message"]
                        let time = jsonResult[i]["_time"]
                        
                        var currentHistory = History(id_c: relID!.toInt()!, _from: from!.toInt()!, _to: to!.toInt()!, message: message!, _time: time!);
                        
                        self.history.append(currentHistory);
                        
                    }
                }
                println(JSON)
                
                if self.history.count > 0 {
                    
                    let partnerUserId = self.userInfo[0] as! Int
                    let partnerUserName = self.userInfo[1] as! String
                    let myUserName = userUsername
                    var currentFromUserId = -1000
                    
                    for historyItem in self.history {
                        
                        if historyItem._from != currentFromUserId {
                            currentFromUserId = historyItem._from
                            self.cellMetas.append(CellMeta( partnerUserId == currentFromUserId ? NSTextAlignment.Left : NSTextAlignment.Right, "cell_info", partnerUserId == currentFromUserId ? partnerUserName : myUserName))
                        }
                        
                        self.cellMetas.append(CellMeta( partnerUserId == historyItem._from ? NSTextAlignment.Left : NSTextAlignment.Right, "cell_message", historyItem.message))
                        
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
