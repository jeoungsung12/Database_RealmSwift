//
//  Reusable.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit

extension UITableViewCell {
    static var id: String {
       return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var id: String {
       return String(describing: self)
    }
}
