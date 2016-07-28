# COGCC MIT Scraper

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

nbsp = Nokogiri::HTML("&nbsp;").text

# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }

  begin

    page_url = "http://cogcc.state.co.us/cogis/IncidentSearch.asp"

    page = agent.get(page_url)

    search_form = page.form_with(name: 'cogims2')

    search_form.radiobuttons_with(name: 'itype')[5].check
#    search_form.field_with(name: 'Date1').value = '01/01/1990'
#    search_form.field_with(name: 'Date2').value = '12/31/2009'
    search_form.field_with(name: 'Date1').value = '01/01/2010'
    search_form.field_with(name: 'Date2').value = '09/10/2015'
    search_form.field_with(name: 'maxrec').value = 5000
    search_results = search_form.submit

    page = agent.submit(search_form)

    # get http response code to check for valid url
    response = page.code.to_s

    # retreive body html
    doc = Nokogiri::HTML(page.body)

    results_table = doc.xpath('//table[2]')

     results_table.css('tr').each_with_index do |tr,i|

       if i >= 2 then

         m = MechanicalIntegrityTests.new

         m.document_number = tr.xpath('td[1]').text.gsub(nbsp, " ").strip
         m.facility_id = tr.xpath('td[2]').text.gsub(nbsp, " ").strip
         m.well_api_number = tr.xpath('td[3]').text.gsub(nbsp, " ").strip
         m.facility_name = tr.xpath('td[4]').text.gsub(nbsp, " ").strip
         m.test_date = tr.xpath('td[5]').text.gsub(nbsp, " ").strip
         m.test_type = tr.xpath('td[6]').text.gsub(nbsp, " ").strip
         m.operator_name = tr.xpath('td[7]').text.gsub(nbsp, " ").strip
         m.operator_number = tr.xpath('td[8]').text.gsub(nbsp, " ").strip

         m.save!

       end

     end

    rescue Mechanize::ResponseCodeError => e
      puts "ResponseCodeError: " + e.to_s
    end


  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end