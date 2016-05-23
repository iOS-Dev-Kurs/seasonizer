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
    
 
 
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    // 1
    override func tableView(tableView: UITableView, numberOfRowsInSection section:Int)->Int{
        return accessories?.count ?? 0
    }
    // 2
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell{
        let accessory = accessories![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell",forIndexPath:indexPath); cell.textLabel?.text = accessory.title; cell.imageView?.image = accessory.image
        return cell
    }
    // 3
    // TODO: Implement `prepareForSegue(_:sender:)` to set `selectedAccessory` when the "selectedAccessory" Segue is performed.
    // HINT: Obtain the selected index path with:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //
        switch segue.identifier! {
                case "selectedAccessory":
                    guard let indexPath = tableView.indexPathForSelectedRow else {
                        return
                }
                selectedAccessory = accessories![indexPath.row]
                default:
                    break
        }
        //
    }
}


// MARK: - Table View Data Source





// TODO: Implement the `UITableViewDataSource` protocol.
