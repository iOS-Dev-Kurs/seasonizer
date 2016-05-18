//
//  AccessoryListViewController.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit


class AccessoryListViewController: UITableViewController {

    // MARK: Model
    
    var accessories: [Accessory]?
    var selectedAccessory: Accessory?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        self.selectedAccessory = accessories?[indexPath.item]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let count = accessories?.count else{
            return 0
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryCell", forIndexPath: indexPath)
        
        
        cell.imageView?.image = accessories?[indexPath.item].image
        cell.textLabel?.text = accessories?[indexPath.item].title
        return cell
    }
}