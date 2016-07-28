#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Environmental Sample Site Infomation/Test Results Scraper

# UNIX shell script to run scraper: while true; do ./import_enviro_sample_results.rb & sleep 3; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'csv'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'environmental_sample_sites'
require mappings_directory + 'environmental_sample_results'

start_time = Time.now

# Establish a database connection
ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

if EnvironmentalSampleSites.where(in_use: true).count == 0 then

EnvironmentalSampleSites.find_by_sql("SELECT * FROM environmental_sample_sites WHERE in_use IS FALSE AND sample_results_imported IS FALSE ORDER BY sample_site_id LIMIT 1").each do |l|

# 267801,268905 skipped due to error

  csv_file = "/Users/troyburke/Data/cogcc_query_database/scripts/import/enviro_samples/#{l.sample_site_id}.csv"

  puts csv_file

  l.in_use = true
  l.save!

  ActiveRecord::Base.transaction do

  begin

    csv_text = File.read(csv_file)

    csv = CSV.parse(csv_text, :headers => true)

    sleep_sec = (csv.size/300).round

    csv.each do |row|

      row.map

      s = EnvironmentalSampleResults.new

      s.environmental_sample_site_id = l.id
      s.sample_site_id = l.sample_site_id
      s.sample_id = row[1]
      s.sample_date = row[2]
      s.matrix = row[3]
      s.lab_id = row[4]
      s.lab_sample_id = row[5]
      s.sampler = row[6]
      s.method_code = row[7]
      s.parameter_name = row[8]
      s.parameter_description = row[9]
      s.result_value = row[10]
      s.units = row[11]
      s.detection_limit = row[12]
      s.qualifier = row[13]

      s.save!

    end # end csv row loop

    l.sample_results_imported = true
    l.in_use = false
    l.save!

    puts "Results imported!"

  rescue Exception => e

    l.sample_results_imported = true
    l.in_use = false
    l.save!

    puts e.message
    puts "No results found!"

  end # error trap

  end # end transaction    

end # end location (sample site) loop

end # in use check

puts "Time Start: #{start_time}"
puts "Time End: #{Time.now}"
