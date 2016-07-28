#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# DWR Aquifer Determination Tool Downloader

#  while true; do ./aquifer_pdf_downloader.rb & sleep 5; done 


# Include required classes and models:

require '../public_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'dwr_denver_aquifer_reports'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]
  puts agent_alias
  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }
  agent.ignore_bad_chunking = true

  download_url = "http://www.dwr.state.co.us/SB5/PDFOutput.aspx"
  search_url = "http://www.dwr.state.co.us/SB5/DenverSpecificLoc.aspx"

  if DwrDenverAquiferReports.where(in_use: true).count == 0 then

  DwrDenverAquiferReports.find_by_sql("SELECT * FROM dwr_denver_aquifer_reports WHERE pdf_downloaded IS FALSE AND in_use IS FALSE LIMIT 1").each do |w|

    w.in_use = true
    w.save!

    puts w.inspect

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
    download_form['tbxGroundElev'] = "#{w.elevation}"
    download_form['tbxAcres'] = "40"
    download_form['tbxSectionNum'] = "#{w.section}"
    download_form['tbxTownshipNum'] = "#{w.twp}"
    download_form['ddlTownshipDir'] = "#{w.twp_dir}"
    download_form['tbxRangeNum'] = "#{w.rng}"
    download_form['ddlRangeDir'] = "West"
    download_form['tbxVertDist'] = "#{w.vert_dist}"
    download_form['ddlVertDir'] = "#{w.vert_dir}"
    download_form['tbxHorizDist'] = "#{w.hor_dist}"
    download_form['ddlHorizDir'] = "#{w.hor_dir}"
    download_form['BtnGenOutput'] = "Generate Output"

    response = download_form.submit

    file_name = "qc_aquifer_pdfs/denver_aquifer_report_#{w.well_id}.pdf"

    puts file_name

    response = agent.get(download_url)

    #File.open(file_name, 'wb'){|f| f << response.body}

    response.save file_name

    w.pdf_downloaded = true
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