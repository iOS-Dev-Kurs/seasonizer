//
//  AccessoryListView.swift
//  Seasonizer
//
//  Created by Marvin A. Ruder on 5/9/16.
//  Copyright © 2016 Nils Fischer. All rights reserved.
//

import UIKit


class AccessoryCell: UITableViewCell {
    
    @IBOutlet var accessoryLabel: UILabel!
    
    func addName(name: String) {
        accessoryLabel.text = name
    }
    
}
