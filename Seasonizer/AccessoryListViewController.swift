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
    
    private var indexOfSelectedAccessory = 0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectedAccessory" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            selectedAccessory = accessories![indexPath.row]
        }
    }

    // MARK: User Interaction
    
    // TODO: Implement `prepareForSegue(_:sender:)` to set `selectedAccessory` when the "selectedAccessory" Segue is performed.
    /*
     HINT: Obtain the selected index path with:
     
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

    */
    

// MARK: - Table View Data Source

// TODO: Implement the `UITableViewDataSource` protocol.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (accessories?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.imageView!.image = accessories![indexPath.row].image
        cell.textLabel!.text = accessories![indexPath.row].title
        return cell
    }
}