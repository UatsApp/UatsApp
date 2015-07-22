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
    
    @IBOutlet var historyTable: UITableView!
    let cellHistory = "cell_message"
    var user: String!
    var history:[History] = []
    var userInfo:NSArray = []
    
    @IBOutlet weak var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkRelation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userInfo[1] as? String
        historyTable.delegate = self
        historyTable.dataSource = self
        println(userInfo[1])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkRelation(){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userUsername = prefs.valueForKey("USERNAME") as! String
        Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/history.php", parameters: ["identifier": "\(userInfo[0])" , "loggedUsername":"\(userUsername)"], encoding: .JSON)
            .responseJSON { _, _, JSON, _ in
                if let jsonResult = JSON?.valueForKey("history") as? Array<Dictionary<String,String>>{
                    var i = 0
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
                self.historyTable.reloadData()
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellHistory, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let messages = history.map({$0.message})
        let from = history.map({$0._from})
        println(messages[row])
        var it:Int = from[row]
        var muie: AnyObject = userInfo[0]
        var textAlign:NSTextAlignment
        println("i\(muie)")
        //        if(4 != 3){
        //            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: cellHistory)
        //        }else{
        //            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: cellHistory)
        //        }
        cell.textLabel?.text = messages[row]
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
