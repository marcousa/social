//
//  CircleImageView.swift
//  Social
//
//  Created by Marco De Filippo on 11/11/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView, lightShadow {

    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(toItem: layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
