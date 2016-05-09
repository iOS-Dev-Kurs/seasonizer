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
    
    // TODO: Implement `prepareForSegue(_:sender:)` to set `selectedAccessory` when the "selectedAccessory" Segue is performed.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        selectedAccessory = accessories![indexPath.row]
    }
    /*
     HINT: Obtain the selected index path with:
     
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

    */

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryCell", forIndexPath: indexPath) as! AccessoryCell
        let currentCell = accessories![indexPath.row]
        cell.addName(currentCell.title)
        return cell
    }

}


// MARK: - Table View Data Source

// TODO: Implement the `UITableViewDataSource` protocol.

