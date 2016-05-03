//
//  NearbyViewController.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 4/21/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyViewController: UITableViewController {
	var stations:[Station] = [];

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		tableView.registerCell("StationCell")

		let loc = CLLocation(latitude: 35.7021, longitude: 139.7753)
		async({ stationsCloseToLocation(loc.coordinate, delta: 5000, count: 50)}) { result in
			self.stations = result
			self.tableView.reloadData()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return stations.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath)
		let station = stations[indexPath.row]
		cell.textLabel?.text = station.name
		cell.detailTextLabel?.text = "\(station.id) [\(station.groupId)] \(station.coordinate.latitude), \(station.coordinate.longitude)"


		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

//		let viewController = StationViewController()
		let viewController = storyboard?.instantiateViewControllerWithIdentifier("station") as! StationViewController
		viewController.station = stations[indexPath.row]
	
		navigationController?.pushViewController(viewController, animated: true)
	}
}

