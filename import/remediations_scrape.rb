# COGCC Remediation Scraper

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require "mechanize"
require "nokogiri"

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'remediations'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  # use random browser
  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]

  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

  puts agent_alias

  page_url = "http://cogcc.state.co.us/cogis/IncidentSearch.asp"

  nbsp = Nokogiri::HTML("&nbsp;").text

  begin

    page = agent.get(page_url)

    search_form = page.form_with(name: 'cogims2')

    search_form.radiobuttons_with(name: 'itype')[4].check
#    search_form.field_with(name: 'Date1').value = '01/01/1980'
#    search_form.field_with(name: 'Date2').value = '12/31/2010'
    search_form.field_with(name: 'Date1').value = '01/01/2011'
    search_form.field_with(name: 'Date2').value = '09/11/2015'
    search_form.field_with(name: 'maxrec').value = 5000
    search_results = search_form.submit

    page = agent.submit(search_form)

    # get http response code to check for valid url
    response = page.code.to_s

    # retreive body html
    doc = Nokogiri::HTML(page.body)

    results_table = doc.xpath('//table[2]')

    if doc.at('th:contains("No Records Found.")').nil? then

      results_table.css('tr').each_with_index do |tr,i|

        if i >= 2 then

          r = Remediations.new

          r.submit_date = tr.xpath('td[1]').text.gsub(nbsp, " ").strip
          r.document_number = tr.xpath('td[2]').text.gsub(nbsp, " ").strip
          r.document_url = tr.xpath('td[2]').at('a')['href'].to_s
          r.project_number = tr.xpath('td[3]').text.gsub(nbsp, " ").strip
          r.facility_type = tr.xpath('td[4]').text.gsub(nbsp, " ").strip
          r.facility_id = tr.xpath('td[5]').text.gsub(nbsp, " ").strip
          r.operator_name = tr.xpath('td[6]').text.gsub(nbsp, " ").strip
          r.operator_number = tr.xpath('td[7]').text.gsub(nbsp, " ").strip

          r.save!

        end

      end # end table row loop

    end # record check

  rescue Mechanize::ResponseCodeError => e
    puts "ResponseCodeError: " + e.to_s
  end

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end