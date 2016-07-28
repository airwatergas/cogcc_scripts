#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# MIT Details Scraper

# UNIX shell script to run scraper: while true; do ./mit_details_scrape.rb & sleep 6; done

# Include required classes and models:


# url=http://cogcc.state.co.us/cogis/IncidentSearch.asp
# itype=mit
# ApiCountyCode=123
# ApiSequenceCode=05444
# maxrec=100

# well links => MITReport.asp?doc_num=200405260 

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require "mechanize"
require "nokogiri"

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'mechanical_integrity_tests'


start_time = Time.now

nbsp = Nokogiri::HTML("&nbsp;").text

# Establish a database connection
ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

# begin error trapping
begin

#2477061
#2337015
#2477073

  MechanicalIntegrityTests.find_by_sql("SELECT * FROM mechanical_integrity_tests WHERE in_use IS FALSE AND details_scraped IS FALSE ORDER BY id LIMIT 1").each do |mit|

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]

    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

    puts agent_alias

    begin

    puts "#{mit.document_number} in use!"

    mit.in_use = true
    mit.save!

    ActiveRecord::Base.transaction do

      page_url = "http://cogcc.state.co.us/cogis/MITReport.asp?doc_num=#{mit.document_number}"

      page = agent.get(page_url)

      response = page.code.to_s

      doc = Nokogiri::HTML(page.body)

#      facility_stuff = doc.at('td:contains("Type of Facility:")').next_element
#      mit.well_status = facility_stuff.at('font[3]').text.gsub(nbsp, " ").strip
#    	mit.facility_type = facility_stuff.at('font[1]').text.gsub(nbsp, " ").strip
#      mit.facility_status = doc.at('td:contains("Facility Status:")').next_element.text.gsub(nbsp, " ").strip
#      mit.operator_address = doc.at('td:contains("Address:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#      mit.operator_contact = doc.at('td:contains("Operator contact:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#      mit.date_submitted = doc.at('td:contains("Date Submitted:")').next_element.text.gsub(nbsp, " ").strip
#      mit.mit_assigned_by = doc.at('td:contains("MIT Assigned by:")').next_element.text.gsub(nbsp, " ").strip
#      mit.date_received = doc.at('td:contains("Date Rec")').next_element.text.gsub(nbsp, " ").strip
#    	mit.field_rep = doc.at('td:contains("Field Rep:")').next_element.text.gsub(nbsp, " ").strip
#    	mit.approved_date = doc.at('td:contains("Approved Date:")').next_element.text.gsub(nbsp, " ").strip
#    	mit.approved_by = doc.at('td:contains("Approved by:")').next_element.text.gsub(nbsp, " ").strip
#      mit.last_approved_mit = doc.at('td:contains("Last Approved MIT:")').next_element.text.gsub(nbsp, " ").strip

#      if !doc.at('td:contains("Condition of approval:")').nil? then
#        condition_table = doc.at('table:contains("Condition of approval:")')
#        condition_text = condition_table.xpath('tr[3]/td').text
#        cond_appr_text = condition_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
#        cond_appr_text = cond_appr_text.encode!('UTF-8', 'UTF-16')
#        mit.condition_of_approval = cond_appr_text.gsub(nbsp, " ").strip
#      end

#      plss_location = doc.at('td:contains("Location:")').text.gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").split(":")

#    	mit.qtrqtr = plss_location[2].gsub("section","").gsub(/\W/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#    	mit.section = plss_location[3].gsub("township","").gsub(/\W/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#    	mit.township = plss_location[4].gsub("range","").gsub(/\W/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#    	mit.range = plss_location[5].gsub("meridian","").gsub(/\W/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
#    	mit.meridian = plss_location[6].gsub(/\W/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip

#      mit.formation_zones = doc.at('td:contains("Formation Zones:")').next_element.text.gsub(nbsp, " ").strip

#      if !doc.at('td:contains("Repair Type:")').nil? then
#        mit.repair_type = doc.at('td:contains("Repair Type:")').next_element.text.gsub(nbsp, " ").strip
#      end
#     if !doc.at('td:contains("Repair Desc:")').nil? then
#        repair_text = doc.at('td:contains("Repair Desc:")').next_element.text
#        repair_desc_text = repair_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
#        repair_desc_text = repair_desc_text.encode!('UTF-8', 'UTF-16')
#        mit.repair_description = repair_desc_text.gsub(nbsp, " ").strip
#      end

#    	mit.perforation_interval = doc.at('td:contains("Perforation Interval")').next_element.text.gsub(nbsp, " ").strip
#    	mit.open_hole_interval = doc.at('td:contains("Open Hole Interval")').next_element.text.gsub(nbsp, " ").strip
#    	mit.plug_depth = doc.at('td:contains("Cement Plug Depth")').next_element.text.gsub(nbsp, " ").strip
#    	mit.tubing_size = doc.at('td:contains("Tubing Size")').next_element.text.gsub(nbsp, " ").strip
#    	mit.tubing_depth = doc.at('td:contains("Tubing Depth")').next_element.text.gsub(nbsp, " ").strip
#    	mit.top_packer_depth = doc.at('td:contains("Top Packer Depth")').next_element.text.gsub(nbsp, " ").strip
#    	mit.multiple_packers = doc.at('td:contains("Multiple Packers")').next_element.text.gsub(nbsp, " ").strip

      psi_table = doc.xpath("//table//table//td")

      if !psi_table.at('td:contains("10 MIN CASE")').nil? then
      	mit.ten_min_case_psi = psi_table.at('td:contains("10 MIN CASE")').next_element.text.gsub(nbsp, " ").strip
      	mit.five_min_case_psi = psi_table.at('td:contains("5 MIN CASE")').next_element.text.gsub(nbsp, " ").strip
        if !psi_table.at('td:contains("CASE BEFORE")').nil? then
      	  mit.case_before_psi = psi_table.at('td:contains("CASE BEFORE")').next_element.text.gsub(nbsp, " ").strip
        end
      	mit.final_case_psi = psi_table.at('td:contains("FINAL CASE")').next_element.text.gsub(nbsp, " ").strip
        if !psi_table.at('td:contains("FINAL TUBE")').nil? then
      	  mit.final_tube_psi = psi_table.at('td:contains("FINAL TUBE")').next_element.text.gsub(nbsp, " ").strip
      	end
        if !psi_table.at('td:contains("INITIAL TUBE")').nil? then
      	  mit.initial_tube_psi = psi_table.at('td:contains("INITIAL TUBE")').next_element.text.gsub(nbsp, " ").strip
      	end
        if !psi_table.at('td:contains("LOSS OR GAIN")').nil? then
      	  mit.loss_gain_psi = psi_table.at('td:contains("LOSS OR GAIN")').next_element.text.gsub(nbsp, " ").strip
      	end
      	if !psi_table.at('td:contains("START CASE")').nil? then
      	  mit.start_case_psi = psi_table.at('td:contains("START CASE")').next_element.text.gsub(nbsp, " ").strip
      	end
      end


      # insert mit test results
      mit.details_scraped = true
      mit.in_use = false
      mit.save!
      puts "MIT results saved!"  

    end

    rescue Mechanize::ResponseCodeError => e
      puts "ResponseCodeError: " + e.to_s
    end

  end

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end