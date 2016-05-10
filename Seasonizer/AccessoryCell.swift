//
//  AccessoryCell.swift
//  Seasonizer
//
//  Created by Kleimaier, Dennis on 10.05.16.
//  Copyright © 2016 Nils Fischer. All rights reserved.
//

import Foundation
import UIKit

class AccessoryCell: UITableViewCell {
    
    @IBOutlet weak var accessoryName: UILabel!
    
    func Name(name: String){
        accessoryName.text = name
    }
}
