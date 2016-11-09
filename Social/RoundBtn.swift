//
//  RoundBtn.swift
//  Social
//
//  Created by Marco De Filippo on 11/9/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit

class RoundBtn: UIButton, lightShadow {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setShadow(toItem: layer)
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}
