# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'bradenhead_methane_well_distances'


# begin error trapping
begin

  start_time = Time.now
  newline = "\r"
  file_date = "20151209"
  file_name = "methane_sample_site_well_distances_#{file_date}.kml"

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase } )

  kml_string = '<?xml version="1.0" encoding="UTF-8"?>' + newline
  kml_string += '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">' + newline
  kml_string += "  <Document>" + newline

  kml_string += '    <Style id="gas_well">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF0000FF</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="water_well">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FFF00014</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += "    <Folder>" + newline

  BradenheadMethaneWellDistances.find_by_sql("select well_api_number, sample_site_id, well_long, well_lat, sample_site_long, sample_site_lat, distance from bradenhead_methane_well_distances where distance < 804.673").each do |w|

    kml_string += "      <Placemark>" + newline
    kml_string += "        <styleUrl>#gas_well</styleUrl>" + newline
    kml_string += "        <Point>" + newline
    kml_string += "          <coordinates>#{w.well_long},#{w.well_lat},0</coordinates>" + newline
    kml_string += "        </Point>" + newline
    kml_string += "        <description>API: #{w.well_api_number}&lt;br&gt;SampleSiteID: #{w.sample_site_id}&lt;br&gt;Distance: #{w.distance} meters</description>" + newline
    kml_string += "     </Placemark>" + newline

    kml_string += "      <Placemark>" + newline
    kml_string += "        <styleUrl>#water_well</styleUrl>" + newline
    kml_string += "        <Point>" + newline
    kml_string += "          <coordinates>#{w.sample_site_long},#{w.sample_site_lat},0</coordinates>" + newline
    kml_string += "        </Point>" + newline
    kml_string += "        <description>SampleSiteID: #{w.sample_site_id}&lt;br&gt;API: #{w.well_api_number}&lt;br&gt;Distance: #{w.distance} meters</description>" + newline
    kml_string += "     </Placemark>" + newline

  end

  kml_string += "    </Folder>" + newline

  kml_string += "  </Document>" + newline
  kml_string += '</kml>'

  File.open(file_name, 'w') { |file| file.write(kml_string) }

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end

