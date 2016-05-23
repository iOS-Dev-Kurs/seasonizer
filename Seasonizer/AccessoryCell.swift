//
//  AccessoryCell.swift
//  Seasonizer
//
//  Created by Arthur Heimbrecht on 22.5.16.
//  Copyright © 2016 Nils Fischer. All rights reserved.
//

import Foundation
import UIKit


class AccessoryCell: UITableViewCell {
	func configureForAccessory(accessory: Accessory) {
		textLabel?.text = accessory.title
		}
}