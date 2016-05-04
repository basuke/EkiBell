//
//  Shortcut.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 5/3/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit
import MapKit

extension UITableView {
	func registerCell(identifier:String) {
		registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
	}
}

extension MKCoordinateRegion {
	init(center:CLLocationCoordinate2D, radius:CLLocationDistance) {
		let delta = radius * 2
		let R:CLLocationDistance = 40076.5 * 1000
		let R2 = R * cos(M_PI * 2 * center.latitude / 360.0)
		let latitudeDelta:CLLocationDegrees = 360.0 * delta / R
		let longitudeDelta:CLLocationDegrees = 360.0 * delta / (R2 > delta ? R2 : delta)

		self.center = center
		self.span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
	}

	var north: CLLocationDegrees {
		return center.latitude + span.latitudeDelta / 2
	}

	var east: CLLocationDegrees {
		return center.longitude + span.longitudeDelta / 2
	}

	var south: CLLocationDegrees {
		return center.latitude - span.latitudeDelta / 2
	}

	var west: CLLocationDegrees {
		return center.longitude - span.longitudeDelta / 2
	}
}

