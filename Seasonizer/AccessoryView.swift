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
    
    
    // MARK: State Preservation
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let imageData = aDecoder.decodeObject(forKey: "image") as? Data {
            self.image = UIImage(data: imageData)
        }
    }

    override func encode(with aCoder: NSCoder) {
        if let image = self.image {
            aCoder.encode(UIImagePNGRepresentation(image), forKey: "image")
        }
        super.encode(with: aCoder)
    }

}
