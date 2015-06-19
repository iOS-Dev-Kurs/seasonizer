//
//  AccessoryView.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit

class AccessoryView: UIImageView {
    
    init(accessory: Accessory) {
        super.init(image: accessory.image)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        if let image = self.image {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image")
        }
        super.encodeWithCoder(aCoder)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let imageData = aDecoder.decodeObjectForKey("image") as? NSData {
            self.image = UIImage(data: imageData)
        }
    }
    
    
}
