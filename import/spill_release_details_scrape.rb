#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Spill/Release Details

#  while true; do ./spill_release_details_scrape.rb & sleep 8; done

# URLS:
# http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid=438673&type=SPILL%20OR%20RELEASE
# http://cogcc.state.co.us/cogis/SpillReport.asp?doc_num=217365


# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'spill_releases'


# begin error trapping
begin

  start_time = Time.now

  nbsp = Nokogiri::HTML("&nbsp;").text

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  SpillReleases.find_by_sql("SELECT * FROM spill_releases WHERE id not in (4680,4787) AND in_use IS FALSE AND details_scraped IS FALSE ORDER BY id LIMIT 1").each do |s|

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]

    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

    puts agent_alias

    begin

      s.in_use = true
      s.save!

      page_url = "http://cogcc.state.co.us/cogis/#{s.document_url}"

      puts page_url

      page = agent.get(page_url)

      response = page.code.to_s

      doc = Nokogiri::HTML(page.body)

      if s.document_url[0] == "S" then

        # scrape details from html
        if !doc.at('td:contains("Date Rec")').nil? then
          s.date_received = doc.at('td:contains("Date Rec")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Report taken by:")').nil? then
          s.report_taken_by = doc.at('td:contains("Report taken by:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("API number:")').nil? then
          s.api_number = doc.at('td:contains("API number:")').next_element.text.gsub(nbsp, " ").gsub(" ", "").strip
        end
        if !doc.at('td:contains("Facility ID:")').nil? then
          s.facility_id = doc.at('td:contains("Facility ID:")').next_element.text.gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Address:")').nil? then
          s.operator_address = doc.at('td:contains("Address:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Phone:")').nil? then
          s.operator_phone = doc.at('td:contains("Phone:")').next_element.text.gsub(nbsp, " ").gsub(" ", "").strip
        end
        if !doc.at('td:contains("Fax:")').nil? then
          s.operator_fax = doc.at('td:contains("Fax:")').next_element.text.gsub(nbsp, " ").gsub(" ", "").strip
        end
        if !doc.at('td:contains("Operator Contact:")').nil? then
          s.operator_contact = doc.at('td:contains("Operator Contact:")').next_element.text.gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Date of Incident:")').nil? then
          s.incident_date = doc.at('td:contains("Date of Incident:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Type of Facility:")').nil? then
          s.facility_type = doc.at('td:contains("Type of Facility:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Well Name/No")').nil? then
          s.well_name_no = doc.at('td:contains("Well Name/No")').next_element.text.gsub(nbsp, " ").strip
        end

        if !doc.at('td/table/tr/td:contains("qtrqtr:")').nil? then
          s.qtr_qtr = doc.at('td/table/tr/td:contains("qtrqtr:")').text.split("qtrqtr:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td/table/tr/td:contains("section:")').nil? then
          s.section = doc.at('td/table/tr/td:contains("section:")').text.split("section:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td/table/tr/td:contains("township:")').nil? then
          s.township = doc.at('td/table/tr/td:contains("township:")').text.split("township:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td/table/tr/td:contains("range:")').nil? then
          s.range = doc.at('td/table/tr/td:contains("range:")').text.split("range:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td/table/tr/td:contains("meridian:")').nil? then
          s.meridian = doc.at('td/table/tr/td:contains("meridian:")').text.split("meridian:")[1].gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Oil spilled:")').nil? then
          s.oil_spilled = doc.at('td:contains("Oil spilled:")').text.split("Oil spilled:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Recvrd:")').nil? then
          s.oil_recovered = doc.xpath('//table[6]/tr[2]/td[2]').text.split("Recvrd:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Water spilled:")').nil? then
          s.water_spilled = doc.at('td:contains("Water spilled:")').text.split("Water spilled:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Recvrd:")').nil? then
          s.water_recovered = doc.xpath('//table[6]/tr[3]/td[2]').text.split("Recvrd:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Other spilled:")').nil? then
          s.other_spilled = doc.at('td:contains("Other spilled:")').text.split("Other spilled:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Recved:")').nil? then
          s.other_recovered = doc.at('td:contains("Recved:")').text.split("Recved:")[1].gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Current land use:")').nil? then
          s.current_land_use = doc.at('td:contains("Current land use:")').text.split("Current land use:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Weather conditions:")').nil? then
          s.weather_conditions = doc.at('td:contains("Weather conditions:")').text.split("Weather conditions:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Soil/Geology description")').nil? then
          s.soil_geology_description = doc.at('td:contains("Soil/Geology description")').text.split("Soil/Geology description")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Distance in feet to nearest surface water:")').nil? then
          s.distance_to_surface_water = doc.at('td:contains("Distance in feet to nearest surface water:")').text.split("Distance in feet to nearest surface water:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Depth to shallowest GW:")').nil? then
          s.depth_to_ground_water = doc.at('td:contains("Depth to shallowest GW:")').text.split("Depth to shallowest GW:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Wetlands:")').nil? then
          s.wetlands = doc.at('td:contains("Wetlands:")').text.split("Wetlands:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Buildings:")').nil? then
          s.buildings = doc.at('td:contains("Buildings:")').text.split("Buildings:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Livestock:")').nil? then
          s.livestock = doc.at('td:contains("Livestock:")').text.split("Livestock:")[1].gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Water Wells:")').nil? then
          s.water_wells = doc.at('td:contains("Water Wells:")').text.split("Water Wells:")[1].gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Cause of spill:")').nil? then
          spill_cause_text = doc.xpath('//table[6]/tr[15]/td').text
          sp_cause_text = spill_cause_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          sp_cause_text = sp_cause_text.encode!('UTF-8', 'UTF-16')
          s.spill_cause = sp_cause_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Immediate Response:")').nil? then
          immediate_response_text = doc.xpath('//table[6]/tr[17]/td').text
          immed_resp_text = immediate_response_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          immed_resp_text = immed_resp_text.encode!('UTF-8', 'UTF-16')
          s.immediate_response = immed_resp_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Emergency Pits:")').nil? then
          emergency_pits_text = doc.xpath('//table[6]/tr[19]/td').text
          emerg_pits_text = emergency_pits_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          emerg_pits_text = emerg_pits_text.encode!('UTF-8', 'UTF-16')
          s.emergency_pits = emerg_pits_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("How extent determined:")').nil? then
          extent_determination_text = doc.xpath('//table[6]/tr[21]/td').text
          extent_det_text = extent_determination_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          extent_det_text = extent_det_text.encode!('UTF-8', 'UTF-16')
          s.extent_determination = extent_det_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Further Remediation")').nil? then
          further_remediation_text = doc.xpath('//table[6]/tr[23]/td').text
          further_rem_text = further_remediation_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          further_rem_text = further_rem_text.encode!('UTF-8', 'UTF-16')
          s.further_remediation = further_rem_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Prevent Problem:")').nil? then
          problem_prevention_text = doc.xpath('//table[6]/tr[25]/td').text
          prob_prevent_text = problem_prevention_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          prob_prevent_text = prob_prevent_text.encode!('UTF-8', 'UTF-16')
          s.problem_prevention = prob_prevent_text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Detailed Description:")').nil? then
          detail_description_text = doc.xpath('//table[6]/tr[27]/td').text
          detail_desc_text = detail_description_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          detail_desc_text = detail_desc_text.encode!('UTF-8', 'UTF-16')
          s.detailed_description = detail_desc_text.gsub(nbsp, " ").strip
        end

        if !doc.at('td:contains("Final Resolution")').nil? then
          resolution_table = doc.at('table:contains("Final Resolution")')
          s.resolution_date = resolution_table.xpath('tr[3]/td[1]').text.gsub(nbsp, " ").strip
          s.case_closed = resolution_table.xpath('tr[3]/td[3]').text.gsub(nbsp, " ").strip
          s.letter_sent = resolution_table.xpath('tr[3]/td[5]').text.gsub(nbsp, " ").strip
          s.cogcc_person = resolution_table.xpath('tr[3]/td[7]').text.gsub(nbsp, " ").strip
          final_resolution_text = resolution_table.xpath('tr[4]/td').text
          final_res_text = final_resolution_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          final_res_text = final_res_text.encode!('UTF-8', 'UTF-16')
          s.final_resolution = final_res_text.gsub(nbsp, " ").strip
        end

      else

        # scrape limited details
        if !doc.at('td:contains("Facility ID:")').nil? then
          s.facility_id = doc.at('td:contains("Facility ID:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Facility Status:")').nil? then
          s.facility_status = doc.at('td:contains("Facility Status:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Facility Name/No:")').nil? then\
          s.facility_name_no = doc.at('td:contains("Facility Name/No:")').next_element.text.gsub(" /", "").gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Status Date:")').nil? then
          s.status_date = doc.at('td:contains("Status Date:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("County:")').nil? then
          county = doc.at('td:contains("County:")').next_element.text.gsub(nbsp, " ").strip
          c_name = county.split("#").first
          s.county_name = c_name.gsub("-","").strip
          s.county_fips = county.split("#").last
        end
        if !doc.at('td:contains("Location:")').nil? then
          s.location = doc.at('td:contains("Location:")').next_element.text.gsub(nbsp, " ").strip
        end
        if !doc.at('td:contains("Lat/Long:")').nil? then
          lat_long = doc.at('td:contains("Lat/Long:")').next_element.text.gsub(nbsp, " ").strip
          s.latitude = lat_long.split("/").first
          s.longitude = lat_long.split("/").last
        end
        if !doc.at('td:contains("Comment:")').nil? then
          s.comment = doc.at('td:contains("Comment:")').next_element.text.gsub(nbsp, " ").strip
        end

      end

      s.details_scraped = true
      s.in_use = false
      s.save!

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