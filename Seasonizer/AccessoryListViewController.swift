//
//  AccessoryListViewController.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit

protocol AccessoryListViewControllerDelegate {
    func accessoriesForAccessoryListViewController(accessoryListViewController: AccessoryListViewController) -> [Accessory]
    func accessoryListViewController(accessoryListViewController: AccessoryListViewController, didSelectAccessory accessory: Accessory)
    func accessoryListViewControllerDidCancel(accessoryListViewController: AccessoryListViewController)
}

class AccessoryListViewController: UITableViewController {

    var delegate: AccessoryListViewControllerDelegate?
    var accessories: [Accessory]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.accessories = self.delegate?.accessoriesForAccessoryListViewController(self)
    }
    
    // MARK: User Interaction
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.delegate?.accessoryListViewControllerDidCancel(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let accessory = accessories![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = accessory.title
        cell.imageView?.image = accessory.image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessory = accessories![indexPath.row]
        self.delegate?.accessoryListViewController(self, didSelectAccessory: accessory)
    }

}
