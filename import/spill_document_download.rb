#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Spill Report Downloader

# DOWNLOAD LINK => http://ogccweblink.state.co.us/DownloadDocument.aspx?DocumentId=_document_id_

# UNIX shell script to run scraper: while true; do ./spill_document_download.rb & sleep 10; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'spill_release_documents'

# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  SpillReleaseDocuments.find_by_sql("SELECT * FROM spill_release_documents WHERE in_use IS FALSE AND primary_document IS TRUE AND document_downloaded IS FALSE LIMIT 1").each do |doc|

    doc.in_use = true
    doc.save!

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]
    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }
    puts agent_alias

    download_link = "http://ogccweblink.state.co.us/DownloadDocument.aspx?DocumentId=#{doc.document_id}"
    puts download_link

    form_19 = agent.get(download_link)

    file_extension = form_19.filename.split('.').last

    file_name = "spill_pdf_reports/#{doc.facility_id}_#{doc.document_number}__#{doc.document_id}___#{doc.document_date}.#{file_extension}"
    puts file_name

    form_19.save file_name

    doc.document_downloaded = true
    doc.in_use = false
    doc.save

    puts "Document downloaded!"

  end

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end