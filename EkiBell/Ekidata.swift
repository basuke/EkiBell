//
//  Ekidata.swift
//  EkiBell
//
//  Created by Basuke Suzuki on 4/24/16.
//  Copyright © 2016 Basuke Suzuki. All rights reserved.
//

import UIKit
import SQLite
import CoreLocation
import MapKit

let STATIONS = Table("stations")
let LINES = Table("lines")
let ID = Expression<Int>("id")
let NAME = Expression<String>("name")
let SHORT_NAME = Expression<String>("short_name")
let COLOR = Expression<Int?>("color")
let ICON_NAME = Expression<String?>("icon_name")
let LATITUDE = Expression<Double>("latitude")
let LONGITUDE = Expression<Double>("longitude")
let GROUP_ID = Expression<Int>("group_id")
let LINE_ID = Expression<Int>("line_id")
let TYPE = Expression<Int>("type")
let SORT = Expression<Int>("sort")

extension Row {
	var id: Int { return get(ID) }
	var name: String { return get(NAME) }
	var shortName: String { return get(SHORT_NAME) }
	var color: Int? { return get(COLOR) }
	var iconName: String? { return get(ICON_NAME) }
	var lineId: Int { return get(LINE_ID) }
	var latitude: Double { return get(LATITUDE) }
	var longitude: Double { return get(LONGITUDE) }
	var groupId: Int { return get(GROUP_ID) }
	var type: Int { return get(TYPE) }
	var sort: Int { return get(SORT) }
}

struct Line {
	var id: Int
	var name: String
	var shortName: String
	var color: Int?
	var iconName: String?

	init(row:Row) {
		id = row.id
		name = row.name
		shortName = row.shortName
		color = row.color
		iconName = row.iconName
	}
}

struct Station {
	var id: Int
	var name: String
	var lineId: Int
	var coordinate: CLLocationCoordinate2D
	var groupId: Int
	var stations: [Station]?

	init(row:Row) {
		id = row.id
		name = row.name
		lineId = row.lineId
		coordinate = CLLocationCoordinate2D(latitude: row.latitude, longitude: row.longitude)
		groupId = row.groupId
	}

	var location: CLLocation {
		return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}

	var line: Line {
		return lineWithId(lineId)
	}

	var lines: [Line] {
		return [line]
	}

	func distanceFrom(location:CLLocation) -> CLLocationDistance {
		return self.location.distanceFromLocation(location)
	}

	func sameStation(other:Station) -> Bool {
		return name == other.name && coordinate.latitude == other.coordinate.latitude && coordinate.longitude == other.coordinate.longitude
	}

	mutating func add(station:Station) {
		if stations == nil {
			stations = []
		}

		stations!.append(station)
	}
}

func allStations() -> [Station] {
	return rowsToStations(try! Ekidata.shared.db.prepare(STATIONS))
}

func stationsCloseToLocation(center:CLLocationCoordinate2D, delta:CLLocationDistance, count:Int) -> [Station] {

	let R:CLLocationDistance = 40076.5 * 1000
	let R2 = R * cos(M_PI * 2 * center.latitude / 360.0)
	let latitudeDelta:CLLocationDegrees = 360.0 * delta / R
	let longitudeDelta:CLLocationDegrees = 360.0 * delta / (R2 > delta ? R2 : delta)
	let south = center.latitude - latitudeDelta / 2
	let north = center.latitude + latitudeDelta / 2
	let west = center.longitude - longitudeDelta / 2
	let east = center.longitude + longitudeDelta / 2

	let stations = rowsToStations(Ekidata.shared.prepare(
		STATIONS
			.filter(south...north ~= LATITUDE)
			.filter(west...east ~= LONGITUDE)
		))
	return sortStations(stations, byDistanceFromLocation:CLLocation(latitude: center.latitude, longitude: center.longitude))
}

private func rowsToStations(rows:AnySequence<Row>) -> [Station] {
	var result:[Station] = []

	for row in rows {
		result.append(Station(row: row))
	}

	return result
}

func stationWithId(id:Int) -> Station {
	let row = Ekidata.shared.db.pluck(STATIONS.filter(ID == id).limit(1))!
	return Station(row: row)
}

func lineWithId(id:Int) -> Line {
	let row = Ekidata.shared.db.pluck(LINES.filter(ID == id).limit(1))!
	return Line(row: row)
}

func sortStations(stations:[Station], byDistanceFromLocation location:CLLocation) -> [Station] {
	return stations.map({ ($0, $0.distanceFrom(location)) }) // (station, distance from ceneter
		.sort({ (a1, a2) in
			let (s1, d1) = a1, (s2, d2) = a2

			if d1 < d2 {
				return true
			} else if d1 > d2 {
				return false
			}

			if s1.groupId == s1.id {
				return true
			}
			return s1.id < s2.id
		})
		.map({ $0.0 })
}

class Ekidata {
	static let shared = Ekidata(path:dbPath)

	static var dbPath: String {
		return NSBundle.mainBundle().pathForResource("ekidata", ofType: "db")!
	}

	let db:Connection

	private init(path:String) {
		db = try! Connection(path, readonly: true)
		db.trace({ print($0) })
	}

	func prepare(query:QueryType) -> AnySequence<Row> {
		return try! db.prepare(query)
	}
}
