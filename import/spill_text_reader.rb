# COGCC Spill Report Text File Reader

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'spill_release_documents'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  SpillReleaseDocuments.find_by_sql("SELECT * FROM spill_release_documents WHERE document_downloaded IS TRUE AND text_imported IS FALSE").each do |r|

  begin

    text_file_name = "spill_text_files/#{r.facility_id}_#{r.document_number}__#{r.document_id}___#{r.document_date}.txt"

    puts "#{r.facility_id}_#{r.document_number}__#{r.document_id}___#{r.document_date}.txt"

    file_text = IO.read(text_file_name)

    doc_text = file_text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    doc_text = doc_text.encode!('UTF-8', 'UTF-16')

    puts doc_text

    r.report_text = doc_text
    r.text_imported = true
    r.save!

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
