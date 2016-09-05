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
        if let identifier = segue.identifier {
            switch identifier {
                case "choseAccessory":
                    guard let indexPathRow = tableView.indexPathForSelectedRow?.row else {break}
                    self.selectedAccessory = accessories![indexPathRow]
                case "cancelAccessories":
                    return
            default:
                return
            }
        }
    }
    // TODO: Implement `prepareForSegue(_:sender:)` to set `selectedAccessory` when the "selectedAccessory" Segue is performed.
    /*
     HINT: Obtain the selected index path with:
     
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

    */

}

extension AccessoryListViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accessories != nil {
            return accessories!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryListCell", forIndexPath: indexPath)
            cell.imageView?.image = accessories?[indexPath.row].image
            cell.textLabel?.text = accessories?[indexPath.row].title
        return cell
    }
}
// MARK: - Table View Data Source

// TODO: Implement the `UITableViewDataSource` protocol.
