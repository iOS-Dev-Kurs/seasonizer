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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "selectedAccessory":
            guard let indexPath = tableView.indexPathForSelectedRow else { break }
            self.selectedAccessory = accessories![indexPath.row]
        default:
            break
        }
    }

}


// MARK: - Table View Data Source

extension AccessoryListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accessories = self.accessories else { return 0 }
        return accessories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accessory = accessories![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessoryCell", for: indexPath)
        cell.textLabel?.text = accessory.title
        cell.imageView?.image = accessory.image
        return cell
    }

}
