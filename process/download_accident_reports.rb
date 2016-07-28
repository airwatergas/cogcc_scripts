#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Accident Report Downloader

# DOWNLOAD LINK => http://ogccweblink.state.co.us/DownloadDocument.aspx?DocumentId=_document_id_

# UNIX shell script to run scraper: while true; do ./download_accident_reports.rb & sleep 10; done

# 444 documents targeted
# 1 failed download (document_id = 3270727)
# 236 PDFs
# 206 TIFs
# 1 XLS



# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'accident_reports'

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

  if AccidentReports.where(in_use: true).count == 0 then

  AccidentReports.find_by_sql("SELECT id, document_id, document_date, document_number, well_api_number FROM accident_reports WHERE report_downloaded IS FALSE AND in_use IS FALSE LIMIT 1").each do |doc|

    doc.in_use = true
    doc.save!

    download_link = "http://ogccweblink.state.co.us/DownloadDocument.aspx?DocumentId=#{doc.document_id}"

    puts download_link

    form_22 = agent.get(download_link)

    file_extension = form_22.filename.split('.').last

    if file_extension[0..2] != 'asp' then
      file_name = "accident_reports/#{file_extension}/form_22_#{doc.well_api_number}_#{doc.document_number}__#{doc.document_id}___#{doc.document_date}.#{file_extension}"
    else
      file_name = "accident_reports/form_22_#{doc.well_api_number}_#{doc.document_number}__#{doc.document_id}___#{doc.document_date}.#{file_extension}"
    end

    puts file_name

    form_22.save file_name

    doc.report_downloaded = true
    doc.in_use = false
    doc.save!

    puts "Document downloaded!"

  end

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end