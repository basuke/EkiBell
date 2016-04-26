# -*- mode:ruby; coding:utf-8 -*-

require 'rubygems'
require 'mechanize'
require 'cgi'

csv_dir = File.dirname(__FILE__) + "/csv"

agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

# login
login_page = agent.get("https://www.ekidata.jp/dl/")

form = login_page.forms[0]
form.ac = 'basuke@siesta.co.jp'
form.ps = "79F9PgBV3aVhBHuiyaWAkYL"

menu_page = agent.submit(form, form.buttons.first)

# menu
download_page = menu_page.links.find { |link| link.text == "データダウンロード" }.click


# download

company_links = []
line_links = []
station_links = []
join_links = []

download_page.links.select do |link|
	link.uri.path == "./f.php"
end.each do |link|
	params = CGI.parse(link.uri.query)
	
	case params['t']
		when ['1']
			links = company_links
			name = 'company'
		when ['3']
			links = line_links
			name = 'line'
		when ['5']
			links = station_links
			name = 'station'
		when ['6']
			links = join_links
			name = 'join'
		else
			links = []
			name = ''
	end
	
	links << {:name => name, :version => params['d'][0], :link => link}
end

company_link = company_links.first
line_link = line_links.first
station_link = station_links.first
join_link = join_links.first

base = File.dirname(__FILE__)
[company_link, line_link, station_link, join_link].each do |info|
	name = info[:name]
	version = info[:version]
	csv = "#{name}#{version}.csv"
	
	path = "#{csv_dir}/#{csv}"
	if not File.exists? path then
		puts "Downloading #{info[:link].uri}"
		agent.download(info[:link].uri, path, [], download_page)
		
		sym = "#{csv_dir}/#{name}.csv"
		if File.exists? sym then
			puts "Delete old symlink"
			File.delete sym
		end
		
		puts "Create new symlink #{sym}"
		File.symlink(csv, sym)
	end
end
