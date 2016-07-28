#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# DWR Aquifer Determination Tool Downloader

#  while true; do ./download_aquifer_depths.rb & sleep 5; done 


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
require mappings_directory + 'denver_aquifer_depth_reports'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]
  puts agent_alias
  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

  download_url = "http://www.dwr.state.co.us/SB5/PDFOutput.aspx"
  search_url = "http://www.dwr.state.co.us/SB5/DenverSpecificLoc.aspx"

  if DougData.where(in_use: true).count == 0 then

  DougData.find_by_sql("SELECT * FROM doug_data WHERE denver_aquifer_pdf_downloaded IS FALSE AND denver_aquifer_pdf_download_failed IS FALSE AND in_use IS FALSE ORDER BY well_api_number LIMIT 1").each do |w|

    begin

    puts w.well_api_number

    w.in_use = true
    w.save!

    search_page = agent.get(search_url)

    download_form = search_page.forms[0]
    download_form['__EVENTTARGET'] = ""
    download_form['__EVENTARGUMENT'] = ""
    download_form['__VIEWSTATE'] = search_page.at('input[@name="__VIEWSTATE"]')['value']
    download_form['__VIEWSTATEGENERATOR'] = search_page.at('input[@name="__VIEWSTATEGENERATOR"]')['value']
    download_form['__EVENTVALIDATION'] = search_page.at('input[@name="__EVENTVALIDATION"]')['value']
    download_form['tbxAppName'] = "test"
    download_form['tbxReceiptNo'] = ""
    download_form['tbxEvaluatedBy'] = ""
    download_form['tbxGroundElev'] = "#{w.elevation_rounded}"
    download_form['tbxAcres'] = "40"
    download_form['tbxSectionNum'] = "#{w.sec}"
    download_form['tbxTownshipNum'] = "#{w.twp_num}"
    download_form['ddlTownshipDir'] = "#{w.twp_dir}"
    download_form['tbxRangeNum'] = "#{w.rng}"
    download_form['ddlRangeDir'] = "West"
    download_form['tbxVertDist'] = "#{w.dist_n_s}"
    download_form['ddlVertDir'] = "#{w.dir_n_s}"
    download_form['tbxHorizDist'] = "#{w.dist_e_w}"
    download_form['ddlHorizDir'] = "#{w.dir_e_w}"
    download_form['BtnGenOutput'] = "Generate Output"

    response = download_form.submit

    file_name = "aquifer_pdfs/denver_aquifer_report_#{w.well_api_number}.pdf"

    puts file_name

    response = agent.get(download_url)

    File.open(file_name, 'wb'){|f| f << response.body}

    w.denver_aquifer_pdf_downloaded = true
    w.in_use = false
    w.save!

    rescue Mechanize::ResponseCodeError => e
      w.denver_aquifer_pdf_download_failed = true
      w.in_use = false
      w.save!
      puts "ResponseCodeError: " + e.to_s
    end

  end # query loop

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end