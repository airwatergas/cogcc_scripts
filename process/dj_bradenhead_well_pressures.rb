# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'dj_bradenhead_wells'
require mappings_directory + 'bradenhead_tests'

# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase } )

  DjBradenheadWells.find_by_sql("select id, well_id from dj_bradenhead_wells order by id").each do |d|

    puts "Well: #{d.well_id}"

    BradenheadTests.find_by_sql("select distinct test_date, surface_casing_psi, end_of_test_psi, final_psi from bradenhead_tests where test_date is not null and all_psi_null is false and well_id = #{d.well_id} order by test_date").each_with_index do |b,i|
      if i == 0
        d.test_date_1 = b.test_date
        d.surface_casing_psi_1 = b.surface_casing_psi
        d.end_of_test_psi_1 = b.end_of_test_psi
        d.final_psi_1 = b.final_psi
      end
      if i == 1
        d.test_date_2 = b.test_date
        d.surface_casing_psi_2 = b.surface_casing_psi
        d.end_of_test_psi_2 = b.end_of_test_psi
        d.final_psi_2 = b.final_psi
      end
      if i == 2
        d.test_date_3 = b.test_date
        d.surface_casing_psi_3 = b.surface_casing_psi
        d.end_of_test_psi_3 = b.end_of_test_psi
        d.final_psi_3 = b.final_psi
      end
      if i == 3
        d.test_date_4 = b.test_date
        d.surface_casing_psi_4 = b.surface_casing_psi
        d.end_of_test_psi_4 = b.end_of_test_psi
        d.final_psi_4 = b.final_psi
      end
      if i == 4
        d.test_date_5 = b.test_date
        d.surface_casing_psi_5 = b.surface_casing_psi
        d.end_of_test_psi_5 = b.end_of_test_psi
        d.final_psi_5 = b.final_psi
      end
      if i == 5
        d.test_date_6 = b.test_date
        d.surface_casing_psi_6 = b.surface_casing_psi
        d.end_of_test_psi_6 = b.end_of_test_psi
        d.final_psi_6 = b.final_psi
      end
      if i == 6
        d.test_date_7 = b.test_date
        d.surface_casing_psi_7 = b.surface_casing_psi
        d.end_of_test_psi_7 = b.end_of_test_psi
        d.final_psi_7 = b.final_psi
      end
      if i == 7
        d.test_date_8 = b.test_date
        d.surface_casing_psi_8 = b.surface_casing_psi
        d.end_of_test_psi_8 = b.end_of_test_psi
        d.final_psi_8 = b.final_psi
      end
      if i == 8
        d.test_date_9 = b.test_date
        d.surface_casing_psi_9 = b.surface_casing_psi
        d.end_of_test_psi_9 = b.end_of_test_psi
        d.final_psi_9 = b.final_psi
      end
      if i == 9
        d.test_date_10 = b.test_date
        d.surface_casing_psi_10 = b.surface_casing_psi
        d.end_of_test_psi_10 = b.end_of_test_psi
        d.final_psi_10 = b.final_psi
      end
      if i == 10
        d.test_date_11 = b.test_date
        d.surface_casing_psi_11 = b.surface_casing_psi
        d.end_of_test_psi_11 = b.end_of_test_psi
        d.final_psi_11 = b.final_psi
      end
      if i == 11
        d.test_date_12 = b.test_date
        d.surface_casing_psi_12 = b.surface_casing_psi
        d.end_of_test_psi_12 = b.end_of_test_psi
        d.final_psi_12 = b.final_psi
      end
      if i == 12
        d.test_date_13 = b.test_date
        d.surface_casing_psi_13 = b.surface_casing_psi
        d.end_of_test_psi_13 = b.end_of_test_psi
        d.final_psi_13 = b.final_psi
      end

    end # tests loop

    d.save!

    puts "Test dates saved!"

  end # end well loop

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end

