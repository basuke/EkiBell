//
//  StationViewController.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 4/21/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var station:Station!;

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var trackButton: UIButton!
	@IBOutlet weak var linesTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		linesTableView.registerCell("LineCell")

		title = station.name

		mapView.region = MKCoordinateRegion(center: station.coordinate, radius:200)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func trackThisStation(sender: AnyObject) {
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return station.lines.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath)
		let line = station.lines[indexPath.row]
		cell.textLabel?.text = line.name

		return cell
	}
}

