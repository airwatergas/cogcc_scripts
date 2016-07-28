#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# NOAV Details Scraper

# UNIX shell script to run scraper: while true; do ./noav_details_scrape.rb & sleep 8; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'noavs'
require mappings_directory + 'noav_details'

start_time = Time.now

nbsp = Nokogiri::HTML("&nbsp;").text

# Establish a database connection
ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

# begin error trapping
begin

  Noavs.find_by_sql("SELECT * FROM noavs WHERE in_use IS FALSE AND details_scraped IS FALSE ORDER BY id LIMIT 1").each do |n|

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]
    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }
    puts agent_alias

    begin

      puts "NOAV Document Number: #{n.document_number}"

      n.in_use = true
      n.save!

      page_url = "http://cogcc.state.co.us/cogis/NOAVReport.asp?doc_num=#{n.document_number}"
      page = agent.get(page_url)
      response = page.code.to_s
      doc = Nokogiri::HTML(page.body)
      operator_table = doc.xpath('//table[1]/tr[3]/td[2]/font[1]')
      violation_table = doc.xpath('//table[2]')
      resolution_table = doc.xpath('//table[3]')

      d = NoavDetails.new
      d.noav_id = n.id

      # operator table
      if !operator_table.at('td:contains("Date Rec")').nil? then
        d.date_received = operator_table.at('td:contains("Date Rec")').next_element.text.gsub(nbsp, " ").strip
      end
      if !operator_table.at('td:contains("Address:")').nil? then
        d.operator_address = operator_table.at('td:contains("Address:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("Company Rep.")').nil? then
        d.operator_rep = operator_table.at('td:contains("Company Rep.")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("Fac.Type:")').nil? then
        d.facility_type = operator_table.at('td:contains("Fac.Type:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("Well Name/No.")').nil? then
        d.well_name_number = operator_table.at('td:contains("Well Name/No.")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("API number:")').nil? then
        d.well_api_number = operator_table.at('td:contains("API number:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("Location")').nil? then
        d.plss_location = operator_table.at('td:contains("Location")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("County")').nil? then
        d.county = operator_table.at('td:contains("County")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("COGCC Rep:")').nil? then
        d.cogcc_rep = operator_table.at('td:contains("COGCC Rep:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/," ").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end
      if !operator_table.at('td:contains("Phone:")').nil? then
        d.phone = operator_table.at('td:contains("Phone:")').next_element.text.gsub(nbsp, " ").gsub(/\s+/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").strip
      end

      # violation table
      if !violation_table.at('td:contains("Approx. time of violation:")').next_element.nil? then
        d.violation_time = violation_table.at('td:contains("Approx. time of violation:")').next_element.text.gsub(nbsp, " ").strip
      end
      violation = doc.at('tr:contains("Date of Alleged Violation")').next_element
      violation_text = violation.at('td').text
      if !violation_text.nil? then
        alleged_vio = violation_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        alleged_vio = alleged_vio.encode!('UTF-8', 'UTF-16')
        d.alleged_violation = alleged_vio.gsub(nbsp, " ").strip
      end
      cite = doc.at('tr:contains("Permit Conditions Cited")').next_element
      cite_text = cite.at('td').text
      if !cite_text.nil? then
        cite_text = cite_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        cite_text = cite_text.encode!('UTF-8', 'UTF-16')
        d.cited_conditions = cite_text.gsub(nbsp, " ").strip
      end
      abatement = doc.at('tr:contains("Performed by Operator")').next_element
      abatement_text = abatement.at('td').text
      if !abatement_text.nil? then
        abate_text = abatement_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        abate_text = abate_text.encode!('UTF-8', 'UTF-16')
        d.abatement = abate_text.gsub(nbsp, " ").strip
      end
      completed_date = doc.at('font:contains("Completed by")')
      if !completed_date.at('font:contains("/")').nil? then
        d.abatement_date = completed_date.at('font:contains("/")').text.gsub(nbsp, " ").strip
      end
      comp_comment = doc.at('tr:contains("Company Comments:")').next_element
      comp_comments = comp_comment.at('td').text
      if !comp_comments.nil? then
        comp_comments = comp_comments.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        comp_comments = comp_comments.encode!('UTF-8', 'UTF-16')
        d.company_comments = comp_comments.gsub(nbsp, " ").strip
      end
    	if !violation_table.at('td:contains("Company Rep:")').nil? then
      	d.company_rep = violation_table.at('td:contains("Company Rep:")').next_element.text.gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('td:contains("Company Rep:")').nil? then
      	d.rep_title = violation_table.at('td:contains("Company Rep:")').next_element.next_element.next_element.text.gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('td:contains("Signature?")').nil? then
      	d.rep_signature = violation_table.at('td:contains("Signature?")').next_element.text.gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('td:contains("Date:")').nil? then
      	d.rep_signature_date = violation_table.at('td:contains("Date:")').next_element.text.gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('table/tr/td/table/tr/td:contains("COGCC Signature?")').nil? then
      	d.cogcc_signature = violation_table.at('table/tr/td/table/tr/td:contains("COGCC Signature?")').text.gsub("COGCC Signature?", "").gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('table/tr/td/table/tr/td:contains("COGCC Signature?")').nil? then
      	d.cogcc_signature_date = violation_table.at('table/tr/td/table/tr/td:contains("Date:")').text.gsub("Date:", "").gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('td:contains("Resolution approved by:")').nil? then
      	d.resolution_approved_by = violation_table.at('td:contains("Resolution approved by:")').text.gsub("Resolution approved by:", "").gsub(nbsp, " ").strip
    	end
    	if !violation_table.at('td:contains("Resolution approved by:")').nil? then
      	d.approved_by_title = violation_table.at('td:contains("Resolution approved by:")').next_element.text.gsub("Title:", "").gsub(nbsp, " ").strip
      end

      # resolution table
    	if !resolution_table.at('tr[3]/td[1]').nil? then
      	d.resolution_date = resolution_table.at('tr[3]/td[1]').text.gsub(nbsp, " ").strip
      end
    	if !resolution_table.at('tr[3]/td[2]').nil? then
      	d.case_closed = resolution_table.at('tr[3]/td[2]').text.gsub(nbsp, " ").strip
      end
    	if !resolution_table.at('tr[3]/td[3]').nil? then
      	d.letter_sent = resolution_table.at('tr[3]/td[3]').text.gsub(nbsp, " ").strip
      end
    	if !resolution_table.at('tr[3]/td[4]').nil? then
      	d.cogcc_person = resolution_table.at('tr[3]/td[4]').text.gsub(nbsp, " ").strip
      end
    	if !resolution_table.at('tr[4]/td[1]').nil? then
      	d.resolution_comments = resolution_table.at('tr[4]/td[1]').text.gsub(nbsp, " ").strip
      end

      puts d.pretty_inspect
      d.save!

      n.details_scraped = true
      n.in_use = false
      n.save!

      puts "NOAV details saved!"

      rescue Mechanize::ResponseCodeError => e
      puts "ResponseCodeError: " + e.to_s
    end

  end # end noav document number loop

   puts "Time Start: #{start_time}"
   puts "Time End: #{Time.now}"

  rescue Exception => e
  puts e.message
end
