//
//  UIView+Extensions.swift
//  PrivateGallery
//
//  Created by Artem Listopadov on 5/6/21.
//  Copyright © 2021 Artem Listopadov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = false
    }
}
