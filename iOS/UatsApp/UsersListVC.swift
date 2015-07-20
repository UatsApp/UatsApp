//
//  UsersListVC.swift
//  UatsApp
//
//  Created by Student on 15/07/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit
import Alamofire

class UsersListVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var usersList:[Users] = []
    var history:[History] = []
    
    
    @IBOutlet var tableView: UITableView!
  
    let cellIdentifier = "cell_text"
    //let someUsers = ["Paul", "Cata", "Boici"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getUsers()

        // Do any additional setup after loading the view.
    }
    
    
    func getUsers(){
        Alamofire.request(.GET, "http://uatsapp.tk/accounts/get_users.php")
            .responseJSON { _, _, JSON, _ in
                if let jsonResult = JSON as? Array<Dictionary<String,String>>{
                    var i = 0
                    for (i = 0; i < jsonResult.count; i++)
                    {
                        let username = jsonResult[i]["username"]
                        let email = jsonResult[i]["email"]
                        let id = jsonResult[i]["id"]
                        
                        var currentUser = Users()
                        currentUser.username = username!
                        currentUser.email = email!
                        currentUser.user_id = id!.toInt()!
                        self.usersList.append(currentUser)
                        println(username)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                println(JSON)
        }
    }
    
    func checkRelation(id:Int, completion: (() -> Void)!){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userUsername = prefs.valueForKey("USERNAME") as! String
        Alamofire.request(.POST, "http://uatsapp.tk/UatsAppWebDEV/history.php", parameters: ["identifier": "\(id)" , "loggedUsername":"\(userUsername)"], encoding: .JSON).responseJSON { _, _, JSON, _ in
            if let jsonResult = JSON as? Array<Dictionary<String,String>>{
                var i = 0
                for (i = 0; i < jsonResult.count; i++)
                {
        
                    let relID = jsonResult[i]["id_c"]
                    let from = jsonResult[i]["_from"]
                    let to = jsonResult[i]["_to"]
                    let message = jsonResult[i]["message"]
                    let time = jsonResult[i]["_time"]
                    
                    var currentHistory = History()
                    currentHistory.id_c = relID!.toInt()!
                    currentHistory._from = from!.toInt()!
                    currentHistory._to = to!.toInt()!
                    currentHistory.message = message!
                    currentHistory._time = time!
                    self.history.append(currentHistory)
                  //  completion()
                }
                
                //self.tableView.reloadData()
              //  completion()
            }
            println(JSON)
            completion()
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    /////////////////////AFISEZ USERNAMEU-RILE////////////////////////////////
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let urr = usersList.map({$0.username})
        cell.textLabel?.text = urr[row]
        return cell
    }
    ////////////////////VAD CINE S-O SELECTAT SI CE ID ARE; FAC PEPARE SEGUE DE USERNAME DEOCAMDATA!!!!! URMEAZA SA FAC DE HISTORY//////////////////
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let urr = usersList.map({$0.user_id})
        let urr_user = usersList.map({$0.username})
        println("lol+\(urr[row])")
        
        self.checkRelation(urr[row]) { () -> Void in
            self.performSegueWithIdentifier("call", sender: urr_user[row])

        }
        
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "call" {
            let chatController = segue.destinationViewController as! ChatViewController
            chatController.user = sender as! String
            
        }
    }


}
