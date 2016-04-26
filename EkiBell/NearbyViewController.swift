//
//  NearbyViewController.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 4/21/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit

class NearbyViewController: UITableViewController {
	var stations:[Station] = [];

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		stations = Ekidata.shared.allStations()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return stations.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		<#code#>
	}
}

