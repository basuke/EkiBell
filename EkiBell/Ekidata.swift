//
//  Ekidata.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 4/24/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit
import SQLite
import CoreGraphics

let STATIONS = Table("stations")
let LINES = Table("lines")
let ID = Expression<Int>("id")
let NAME = Expression<String>("name")
let SHORT_NAME = Expression<String>("short_name")
let COLOR = Expression<Int>("color")
let ICON_NAME = Expression<String>("icon_name")
let LATITUDE = Expression<Double>("latitude")
let LONGITUDE = Expression<Double>("longitude")
let GROUP_ID = Expression<Int>("group_id")
let LINE_ID = Expression<Int>("line_id")
let TYPE = Expression<Int>("type")
let SORT = Expression<Int>("sort")

struct Line {
	var id: Int
	var name: String
	var shortName: String
	var color: Int
	var iconName: String
}

struct Station {
	var id: Int
	var name: String
	var lineId: Int
	var latitude: Double
	var longitude: Double
	var groupId: Int
}

class Ekidata {
	static let shared = Ekidata(path:dbPath)

	static var dbPath: String {
		return NSBundle.mainBundle().pathForResource("ekidata", ofType: "db")!
	}

	let db:Connection

	private init(path:String) {
		db = try! Connection(path, readonly: true)
	}

	func allStations() -> [Station] {
		var result = Array<Station>()

		for row in try! db.prepare(STATIONS) {
			let station = Station(id: row[ID],
								  name: row[NAME],
								  lineId: row[LINE_ID],
								  latitude: row[LATITUDE],
								  longitude: row[LONGITUDE],
								  groupId: row[GROUP_ID])
			result.append(station)
		}

		return result
	}

}
