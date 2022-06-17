//
//  Realm+Extensions.swift
//  PrivateGallery
//
//  Created by Artem Listopadov on 4.08.21.
//  Copyright © 2021 Artem Listopadov. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

