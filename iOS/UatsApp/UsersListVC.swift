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
    //    var history:[History] = []
    
    
    @IBOutlet var tableView: UITableView!
    
    let cellIdentifier = "cell_text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getUsers()
        
        // Do any additional setup after loading the view.
    }
    
    
    func getUsers(){
        
//        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        var LoggedUseUserName = prefs.valueForKey("USERNAME") as! String
//        let (isSessionToken, error) = KeyChain.loadDataForUserAccount("\(LoggedUseUserName)")
//        var token: AnyObject? = isSessionToken!["token"] as! String
//        var userID:AnyObject? = isSessionToken!["user_id"] as! String
//        println("mueicupula\(userID)")
//        println("mueicumizda\(token)")
        
       
        
        Alamofire.request(.POST, "http://46.101.248.188/accounts/get_users.php", parameters: ["token":"\(token)", "uid":"\(userID)"], encoding: .JSON)
            .responseJSON { _, _, JSON in
                if let jsonResult = JSON.value!["friends"] as? Array<Dictionary<String,String>>{
                    var i = 0
                    for (i = 0; i < jsonResult.count; i++)
                    {
                        let username = jsonResult[i]["username"]
                        let email = jsonResult[i]["email"]
                        let id = jsonResult[i]["id"]
                        
                        let currentUser = Users()
                        currentUser.username = username!
                        currentUser.email = email!
                        currentUser.user_id = Int(id!)!
                        self.usersList.append(currentUser)
                        print(username)
                    }
                    self.tableView.reloadData()
                }
                print(JSON)
        }
//        var alertview:UIAlertView = UIAlertView()
//        alertview.title = "Token!"
//        alertview.message = "\(pp!)" as String
//        alertview.delegate = self
//        alertview.addButtonWithTitle("OK")
//        alertview.show()
//        println("USERUL LOGAT ARE TOKENUL: \(pp!)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
        let row = indexPath.row
        let urr = usersList.map({$0.username})
        cell.textLabel?.text = urr[row]
        return cell
    }
    
    
    ////////////////////VAD CINE S-O SELECTAT SI CE ID ARE; FAC PEPARE SEGUE DE USERNAME DEOCAMDATA!!!!! URMEAZA SA FAC DE HISTORY//////////////////
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let user_id = usersList[row].user_id
        let username = usersList[row].username

        let data: NSArray = [user_id, username]
        self.performSegueWithIdentifier("call", sender: data)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "call" {
            let chatController = segue.destinationViewController as! ChatViewController
            chatController.userInfo = sender as! NSArray
        }
    }
    
    
}
