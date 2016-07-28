# Frac Focus Text File Reader

# Include required classes and models:

require '../public_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'dwr_denver_aquifer_reports'

# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  DwrDenverAquiferReports.find_by_sql("SELECT * FROM dwr_denver_aquifer_reports WHERE is_new_download IS TRUE AND text_imported IS FALSE").each do |w|

  begin

    text_file_name = "aquifer_txts/new_reports/denver_aquifer_report_#{w.well_id}.txt"

    puts "denver_aquifer_report_#{w.well_id}.txt"

    file_text = IO.read(text_file_name)

    doc_text = file_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    doc_text = doc_text.encode!('UTF-8', 'UTF-16')

    puts doc_text

    w.report_text = doc_text
    w.text_imported = true
    w.save!

    rescue Exception => e
      puts e.message
    end

  end

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end
