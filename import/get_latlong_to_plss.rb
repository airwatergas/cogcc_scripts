#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# USGS Lat/Long to PLSS Converter tool

#  while true; do ./get_latlong_to_plss.rb & sleep 5; done 


# Include required classes and models:

require '../public_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'
require 'cgi'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'greg_dj_well_plss_values'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]
  puts agent_alias
  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

  if GregDjWellPlssValues.where(in_use: true).count == 0 then

  GregDjWellPlssValues.find_by_sql("SELECT id, well_id, longitude, latitude FROM greg_dj_well_plss_values WHERE plss_converted IS FALSE AND in_use IS FALSE LIMIT 1").each do |w|

    w.in_use = true
    w.save!

    url = "http://www.geocommunicator.gov/TownshipGeocoder/TownshipGeocoder.asmx/GetTRS?Lat=#{w.latitude}&Lon=#{w.longitude}&Units=eDD&Datum=NAD83"

    response = agent.get(url)

    doc_text = CGI.unescapeHTML(response.body)

    doc = Nokogiri::HTML(doc_text)

    plss_desc = doc.xpath('//item[2]/description').text

    puts "#{w.well_id}: #{plss_desc}"

    w.plss = plss_desc
    w.plss_converted = true
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