#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# USGS Elevation tool

#  while true; do ./get_usgs_elevation.rb & sleep 5; done 


# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'well_usgs_elevations'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]
  puts agent_alias
  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

  if WellUsgsElevations.where(in_use: true).count == 0 then

  WellUsgsElevations.find_by_sql("SELECT id, well_id, longitude, latitude FROM well_usgs_elevations WHERE is_denver_basin IS TRUE AND elevation_retreived IS FALSE AND in_use IS FALSE LIMIT 1").each do |w|

    w.in_use = true
    w.save!

    url = "http://ned.usgs.gov/epqs/pqs.php?x=#{w.longitude}&y=#{w.latitude}&units=Feet&output=xml"

    response = agent.get(url)

    xml = Nokogiri::XML(response.body)

    elev = xml.xpath("//Elevation").text

    puts "#{w.well_id}: #{elev}"

    w.elevation = elev
    w.elevation_retreived = true
    w.in_use = false
    w.save!

  end # query loop

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end