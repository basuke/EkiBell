# -*- mode:ruby; coding:utf-8 -*-

require 'rubygems'
require 'sqlite3'
require 'csv'

$base = File.dirname(__FILE__)
$sql_dir = $base + "/sql"
$csv_dir = $base + "/csv"

def run_sql_file(db, name)
	path = "#{$sql_dir}/#{name}.sql"

	File.open(path, 'r') do |file|
		sql = file.read()
		db.execute_batch(sql)
	end
end

db = SQLite3::Database.new("ekidata.db")

run_sql_file(db, "schema")

# import lines
sql = "INSERT INTO lines(id, name, short_name) VALUES (?, ?, ?)"
CSV.table("#{$csv_dir}/line.csv").each do |row|
	f = row.fields
	db.execute sql, [f[0], f[4], f[2]]
end

#import stations
sql = "INSERT INTO stations VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
CSV.table("#{$csv_dir}/station.csv").each do |row|
	f = row.fields
	#   0: station_cd
	#   1: station_g_cd
	#   2: station_name
	#   3: station_name_k
	#   4: station_name_r
	#   5: line_cd
	#   6: pref_cd
	#   7: post
	#   8: add
	#   9: lon
	#   10: lat
	#   11: open_ymd
	#   12: close_ymd
	#   13: e_status
	#   14: e_sort

	# 	0: 1110101,
	# 	1: 1110101,
	# 	2: "函館",
	# 	3: nil,
	# 	4: nil,
	# 	5: 11101,
	# 	6: 1,
	# 	7: "040-0063",
	# 	8: "北海道函館市若松町１２-１３",
	# 	9: 140.726413,
	# 	10: 41.773709,
	# 	11: "1902-12-10",
	# 	12: nil,
	# 	13: 0,
	# 	14: 1110101
	db.execute sql, [f[0],f[2],f[10],f[9],f[1],f[5],f[13],f[14]]
end
