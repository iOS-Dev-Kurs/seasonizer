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
	
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?){
		switch segue.identifier! {
		case "selectedAccessory":
			
			guard let indexPath = self.tableView.indexPathForSelectedRow else {
				return
			}
			self.selectedAccessory = accessories?[indexPath.row] as Accessory?
			print(selectedAccessory!)
		
			//case "unwind":
			
		default:
			break
		}
		
	}
	
    /*
     HINT: Obtain the selected index path with:
     
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

    */

}


// MARK: - Table View Data Source

// TODO: Implement the `UITableViewDataSource` protocol.

extension AccessoryListViewController {
	override func numberOfSectionsInTableView(tableView:UITableView)->Int{return 1} // Wir zeigen die Kontakte zunächst in einer einzelnen Section
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section:Int)->Int{
		return accessories!.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell{
		// VIEW-Komponente: Frage die Table View nach einer wiederverwendbarenZelle
		let cell = tableView.dequeueReusableCellWithIdentifier("AccessoryCell", forIndexPath: indexPath) as! AccessoryCell
		// MODEL-Komponente: Bestimme den Kontakt für diese Zeile
		let Accessories = accessories![indexPath.row]
		cell.configureForAccessory(Accessories)
		return cell
	}
	
}

