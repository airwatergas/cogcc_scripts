#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Environmental Sample Site Infomation/Test Results Scraper

# UNIX shell script to run scraper: while true; do ./enviro_sample_well.rb & sleep 5; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'environmental_sample_sites'

start_time = Time.now

nbsp = Nokogiri::HTML("&nbsp;").text


# Establish a database connection
ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

# begin error trapping
begin

  if EnvironmentalSampleSites.where(in_use: true).count == 0 then

  EnvironmentalSampleSites.find_by_sql("SELECT id, sample_site_id FROM environmental_sample_sites WHERE in_use IS FALSE AND related_well_saved IS FALSE ORDER BY id LIMIT 1").each do |s|

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]
    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }
    puts agent_alias

    begin

      puts "Facility ID: #{s.sample_site_id}"
      page_url = "http://cogcc.state.co.us/COGIS/EnviroSample.asp?facid=#{s.sample_site_id}"
      page = agent.get(page_url)
      response = page.code.to_s
      doc = Nokogiri::HTML(page.body)
      site_table = doc.xpath('//table[1]')

      if !site_table.at('td:contains("API Number:")').nil? then
        s.well_api_number = site_table.at('td:contains("API Number:")').next_element.text.gsub(nbsp, " ").strip
        puts "Related sample site well api number #{s.well_api_number} saved!"
      else
        puts "No related well found."
      end
      
      s.related_well_saved = true
      s.in_use = false
      s.save!

    rescue Mechanize::ResponseCodeError => e
      puts "ResponseCodeError: " + e.to_s
      s.in_use = false
      s.save!
    end

  end # end site id loop

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end