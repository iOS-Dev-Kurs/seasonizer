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
    
    
    // MARK: User Interaction
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        selectedAccessory = accessories![indexPath.row]
    }

}


// MARK: - Table View Data Source

extension AccessoryListViewController{
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryCell", forIndexPath: indexPath) as! AccessoryCell
        let currentCell = accessories![indexPath.row]
        cell.Name(currentCell.title)
        cell.imageView?.image = currentCell.image
        return cell
    }
}
