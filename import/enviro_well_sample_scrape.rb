#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Environmental Sample Site Infomation/Test Results Scraper

# UNIX shell script to run scraper: while true; do ./enviro_well_sample_scrape.rb & sleep 5; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'wells'
require mappings_directory + 'environmental_sample_sites'

start_time = Time.now

nbsp = Nokogiri::HTML("&nbsp;").text

# Establish a database connection
ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

# begin error trapping
begin

# well_count | facility_s
# ------------+------------
#    48558 | PR -completed
#    20694 | DA -in progress (> 204579)
#    14416 | PA -completed
#    13444 | AL -skip??
#     5730 | XX -in progress (> 438497)
#     1925 | SI -completed
#     1322 | DG -completed
#      658 | IJ -completed
#      612 | TA -completed
#      299 | AC -completed
#      246 | WO -completed
#       51 | DM -completed
#       21 | UN -completed
#        1 | AB -completed
#        1 | pa -completed

#  Wells.find_by_sql("SELECT facility_i FROM wells WHERE facility_s = 'XX' AND facility_i > 438497 ORDER BY facility_i").each do |w|
#  Wells.find_by_sql("SELECT facility_i FROM wells WHERE facility_s = 'DA' AND facility_i > 204579 ORDER BY facility_i").each do |w|
  Wells.find_by_sql("select facility_id as facility_i from sample_facility_ids order by facility_id").each do |w|

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]
    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }
    puts agent_alias

    begin

      puts "Sample Site Id: #{w.facility_i}"
      page_url = "http://cogcc.state.co.us/COGIS/EnviroSample.asp?facid=#{w.facility_i}"
      page = agent.get(page_url)
      response = page.code.to_s
      doc = Nokogiri::HTML(page.body)
      site_table = doc.xpath('//table[1]')

      s = EnvironmentalSampleSites.new
      s.sample_site_id = w.facility_i

      if !site_table.at('td:contains("FacilityType:")').nil? then
        s.facility_type = site_table.at('td:contains("FacilityType:")').next_element.text.gsub(nbsp, " ").strip
      end
      if !site_table.at('td:contains("ProjNumber:")').nil? then
        s.project_number = site_table.at('td:contains("ProjNumber:")').next_element.text.gsub(nbsp, " ").strip
      end
      if !site_table.at('td:contains("County:")').nil? then
        s.county = site_table.at('td:contains("County:")').next_element.text.gsub(nbsp, " ").strip
      end
      if !site_table.at('td:contains("Location:")').nil? then
        s.plss_location = site_table.at('td:contains("Location:")').next_element.text.gsub(nbsp, " ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !site_table.at('td:contains("Elevation:")').nil? then
        s.elevation = site_table.at('td:contains("Elevation:")').next_element.text.gsub(nbsp, " ").strip
      end
      if !site_table.at('td:contains("Lat/Long:")').nil? then
        lat_long = site_table.at('td:contains("Lat/Long:")').next_element.text.gsub(nbsp, " ").strip
        puts lat_long
        s.longitude = lat_long.split('/')[1]
        s.latitude = lat_long.split('/')[0]
      end
      if !site_table.at('td:contains("DWR Receipt #:")').nil? then
        s.dwr_receipt_number = site_table.at('td:contains("DWR Receipt #:")').next_element.text.gsub(nbsp, " ").strip
      end
      if !site_table.at('td:contains("WellDepth:")').nil? then
        s.well_depth = site_table.at('td:contains("WellDepth:")').next_element.text.gsub(nbsp, " ").strip
      end

      puts s.inspect
      s.save!

      puts "Sample site information saved!"

      sample_links = doc.xpath("//a[starts-with(@href, 'EnviroSample.asp?facid=#{w.facility_i}')]")

      link_count = sample_links.length

      if link_count > 0 then

        a = Array.new
        sample_links.each do |link|
          a.push(link.text)
        end

        sample_ids = a.join(",")

        export_url = "http://cogcc.state.co.us/COGIS/EnviroSample_Export.ashx?facid=#{w.facility_i}&param=#{sample_ids}"

        export = agent.get(export_url)
        file_name = "enviro_samples/#{w.facility_i}.csv"
        export.save file_name
        puts "Samples saved!"

      else

        puts "No samples found."

      end

      sleep(5)

    rescue Mechanize::ResponseCodeError => e
      puts "ResponseCodeError: " + e.to_s
      sleep(2)
    end

  end # end facility id loop

   puts "Time Start: #{start_time}"
   puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end