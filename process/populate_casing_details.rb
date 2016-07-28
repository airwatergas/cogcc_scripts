# Casing Populator

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'casing_details'
require mappings_directory + 'completed_casings'

# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase } )

  CasingDetails.find_by_sql("select id, well_id, sidetrack_id from casing_details order by id").each do |d|

    puts "Well: #{d.well_id}"

    # find completed casings for sidetrack
    casing_count = 1
    CompletedCasings.find_by_sql("select casing_string_type, casing_hole_size, casing_size, casing_top, casing_depth, casing_weight, cement_top, cement_bottom, cement_method_grade from completed_casings where sidetrack_id = #{d.sidetrack_id} and is_additional_cement is false order by id").each do |c|

      case casing_count 
        when 1
          d.casing_1_string_type = c.casing_string_type
          d.casing_1_hole_size = c.casing_hole_size
          d.casing_1_size = c.casing_size
          d.casing_1_depth = c.casing_depth
          d.casing_1_weight = c.casing_weight
          d.casing_1_cement_top = c.cement_top
          d.casing_1_cement_bottom = c.cement_bottom
          d.casing_1_cement_method_grade = c.cement_method_grade
        when 2
          d.casing_2_string_type = c.casing_string_type
          d.casing_2_hole_size = c.casing_hole_size
          d.casing_2_size = c.casing_size
          d.casing_2_depth = c.casing_depth
          d.casing_2_weight = c.casing_weight
          d.casing_2_cement_top = c.cement_top
          d.casing_2_cement_bottom = c.cement_bottom
          d.casing_2_cement_method_grade = c.cement_method_grade
        when 3
          d.casing_3_string_type = c.casing_string_type
          d.casing_3_hole_size = c.casing_hole_size
          d.casing_3_size = c.casing_size
          d.casing_3_depth = c.casing_depth
          d.casing_3_weight = c.casing_weight
          d.casing_3_cement_top = c.cement_top
          d.casing_3_cement_bottom = c.cement_bottom
          d.casing_3_cement_method_grade = c.cement_method_grade
        when 4
          d.casing_4_string_type = c.casing_string_type
          d.casing_4_hole_size = c.casing_hole_size
          d.casing_4_size = c.casing_size
          d.casing_4_depth = c.casing_depth
          d.casing_4_weight = c.casing_weight
          d.casing_4_cement_top = c.cement_top
          d.casing_4_cement_bottom = c.cement_bottom
          d.casing_4_cement_method_grade = c.cement_method_grade
        when 5
          d.casing_5_string_type = c.casing_string_type
          d.casing_5_hole_size = c.casing_hole_size
          d.casing_5_size = c.casing_size
          d.casing_5_depth = c.casing_depth
          d.casing_5_weight = c.casing_weight
          d.casing_5_cement_top = c.cement_top
          d.casing_5_cement_bottom = c.cement_bottom
          d.casing_5_cement_method_grade = c.cement_method_grade
        when 6
          d.casing_6_string_type = c.casing_string_type
          d.casing_6_hole_size = c.casing_hole_size
          d.casing_6_size = c.casing_size
          d.casing_6_depth = c.casing_depth
          d.casing_6_weight = c.casing_weight
          d.casing_6_cement_top = c.cement_top
          d.casing_6_cement_bottom = c.cement_bottom
          d.casing_6_cement_method_grade = c.cement_method_grade
        when 7
          d.casing_7_string_type = c.casing_string_type
          d.casing_7_hole_size = c.casing_hole_size
          d.casing_7_size = c.casing_size
          d.casing_7_depth = c.casing_depth
          d.casing_7_weight = c.casing_weight
          d.casing_7_cement_top = c.cement_top
          d.casing_7_cement_bottom = c.cement_bottom
          d.casing_7_cement_method_grade = c.cement_method_grade
        when 8
          d.casing_8_string_type = c.casing_string_type
          d.casing_8_hole_size = c.casing_hole_size
          d.casing_8_size = c.casing_size
          d.casing_8_depth = c.casing_depth
          d.casing_8_weight = c.casing_weight
          d.casing_8_cement_top = c.cement_top
          d.casing_8_cement_bottom = c.cement_bottom
          d.casing_8_cement_method_grade = c.cement_method_grade
      end

      casing_count = casing_count + 1

    end # end casings

    # find additional cement for sidetrack
    cement_count = 1
    CompletedCasings.find_by_sql("select casing_string_type, cement_top, cement_bottom, cement_method_grade, cement_depth from completed_casings where sidetrack_id = #{d.sidetrack_id} and is_additional_cement is true order by id").each do |a|

      case cement_count
        when 1
          d.add_cement_1_string_type = a.casing_string_type
          d.add_cement_1_top = a.cement_top
          d.add_cement_1_depth = a.cement_depth
          d.add_cement_1_bottom = a.cement_bottom
          d.add_cement_1_method_grade = a.cement_method_grade
        when 2
          d.add_cement_2_string_type = a.casing_string_type
          d.add_cement_2_top = a.cement_top
          d.add_cement_2_depth = a.cement_depth
          d.add_cement_2_bottom = a.cement_bottom
          d.add_cement_2_method_grade = a.cement_method_grade
        when 3
          d.add_cement_3_string_type = a.casing_string_type
          d.add_cement_3_top = a.cement_top
          d.add_cement_3_depth = a.cement_depth
          d.add_cement_3_bottom = a.cement_bottom
          d.add_cement_3_method_grade = a.cement_method_grade
        when 4
          d.add_cement_4_string_type = a.casing_string_type
          d.add_cement_4_top = a.cement_top
          d.add_cement_4_depth = a.cement_depth
          d.add_cement_4_bottom = a.cement_bottom
          d.add_cement_4_method_grade = a.cement_method_grade
        when 5
          d.add_cement_5_string_type = a.casing_string_type
          d.add_cement_5_top = a.cement_top
          d.add_cement_5_depth = a.cement_depth
          d.add_cement_5_bottom = a.cement_bottom
          d.add_cement_5_method_grade = a.cement_method_grade
        when 6
          d.add_cement_6_string_type = a.casing_string_type
          d.add_cement_6_top = a.cement_top
          d.add_cement_6_depth = a.cement_depth
          d.add_cement_6_bottom = a.cement_bottom
          d.add_cement_6_method_grade = a.cement_method_grade
        when 7
          d.add_cement_7_string_type = a.casing_string_type
          d.add_cement_7_top = a.cement_top
          d.add_cement_7_depth = a.cement_depth
          d.add_cement_7_bottom = a.cement_bottom
          d.add_cement_7_method_grade = a.cement_method_grade
        when 8
          d.add_cement_8_string_type = a.casing_string_type
          d.add_cement_8_top = a.cement_top
          d.add_cement_8_depth = a.cement_depth
          d.add_cement_8_bottom = a.cement_bottom
          d.add_cement_8_method_grade = a.cement_method_grade
        when 9
          d.add_cement_9_string_type = a.casing_string_type
          d.add_cement_9_top = a.cement_top
          d.add_cement_9_depth = a.cement_depth
          d.add_cement_9_bottom = a.cement_bottom
          d.add_cement_9_method_grade = a.cement_method_grade
        when 10
          d.add_cement_10_string_type = a.casing_string_type
          d.add_cement_10_top = a.cement_top
          d.add_cement_10_depth = a.cement_depth
          d.add_cement_10_bottom = a.cement_bottom
          d.add_cement_10_method_grade = a.cement_method_grade
        when 11
          d.add_cement_11_string_type = a.casing_string_type
          d.add_cement_11_top = a.cement_top
          d.add_cement_11_depth = a.cement_depth
          d.add_cement_11_bottom = a.cement_bottom
          d.add_cement_11_method_grade = a.cement_method_grade
        when 12
          d.add_cement_12_string_type = a.casing_string_type
          d.add_cement_12_top = a.cement_top
          d.add_cement_12_depth = a.cement_depth
          d.add_cement_12_bottom = a.cement_bottom
          d.add_cement_12_method_grade = a.cement_method_grade
        when 13
          d.add_cement_13_string_type = a.casing_string_type
          d.add_cement_13_top = a.cement_top
          d.add_cement_13_depth = a.cement_depth
          d.add_cement_13_bottom = a.cement_bottom
          d.add_cement_13_method_grade = a.cement_method_grade
        when 14
          d.add_cement_14_string_type = a.casing_string_type
          d.add_cement_14_top = a.cement_top
          d.add_cement_14_depth = a.cement_depth
          d.add_cement_14_bottom = a.cement_bottom
          d.add_cement_14_method_grade = a.cement_method_grade
      end

      cement_count = cement_count + 1

    end # end additional cements

    d.save!
    puts "Data saved!"

  end # end sidetrack loop

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end

