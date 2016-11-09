//
//  FancyBtn.swift
//  Social
//
//  Created by Marco De Filippo on 11/9/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit

class FancyBtn: UIButton, lightShadow {

    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(toItem: layer)
        layer.cornerRadius = 5.0
    }
    
}
