//
//  FriendListVC.swift
//  UatsApp
//
//  Created by Student on 03/08/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit



class FriendListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendListTable.delegate = self
        FriendListTable.dataSource = self
        self.FriendListTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.FriendListTable.reloadData()
        
    }

    
    let cellIdentif = "cell_text"
    var testInfo = ["paul", "cata", "clau"]
    
    @IBOutlet weak var FriendListTable: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentif, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = testInfo[row]
        return cell
    }
    
}