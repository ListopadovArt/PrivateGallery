//
//  UIViewController+Extensions.swift
//  PrivateGallery
//
//  Created by Artem Listopadov on 5/5/21.
//  Copyright © 2021 Artem Listopadov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, complition: (()->Void)!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            complition()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:  nil)
    }
}
