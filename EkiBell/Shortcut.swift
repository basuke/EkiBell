//
//  Shortcut.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 5/3/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit

extension UITableView {
	func registerCell(identifier:String) {
		registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
	}
}
