# -*- mode:ruby; coding:utf-8 -*-

require 'rubygems'
require 'sqlite3'

class Node
	def initialize(s1, s2)
		@from = s1
		@to = s2
	end
end

def segment_desc(segment)
	return "LOOP #{segment.length} stations" if segment.last == segment.first
	return "#{segment.length} stations"
end

def merge(segments0)
	segments = []
	
	segments0.each do |row|
		s1, s2 = row.first, row.last
		
		segment = segments.select {|s| s.first == s2}.first
		if segment then
			row.pop
			segment.unshift *row
			next
		end
		
		segment = segments.select {|s| s.last == s1}.first
		if segment then
			row.shift
			segment.push *row
			next
		end
		
		segments.push row
	end	
	
	return segments if segments.length == segments0.length
	return merge segments
end

def print_result(code, name, segments)
	if segments.length > 1
		puts "#{code}: #{name}"
		
		segments.each do |segment|
			puts segment_desc segment
		end
		puts segments.collect {|row| row.join ","}
		puts
	end
end

db = SQLite3::Database.new("ekidata.db")

db.execute "SELECT line_cd,line_name FROM ed_line" do |row|
	line_code, line_name = row
	
	segments = merge db.execute("SELECT station_cd1,station_cd2 FROM ed_join WHERE line_cd=?", line_code)
	print_result line_code, line_name, segments
end

