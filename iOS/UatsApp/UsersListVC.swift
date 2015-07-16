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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let urr = usersList.map({$0.username})
        cell.textLabel?.text = urr[row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        println(usersList[row])
        let urr = usersList.map({$0.username})
        performSegueWithIdentifier("call", sender: urr[row])
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
