# Include required classes and models:

require '../data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'wells'


# begin error trapping
begin

  start_time = Time.now
  newline = "\r"
  file_date = "20160314"
  file_name = "weld_county_wells_#{file_date}.kml"

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase } )

  kml_string = '<?xml version="1.0" encoding="UTF-8"?>' + newline
  kml_string += '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">' + newline
  kml_string += "  <Document>" + newline

  kml_string += '    <Style id="kerr-mcgee">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF00FF14</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="noble">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FFFF7800</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += "    <Folder>" + newline

  Wells.find_by_sql("select id, lpad(id::varchar,8,'0') as link_fld, api_number, longitude, latitude, operator_number, operator_name from wells where operator_number in (47120,100322) order by api_number").each do |w|

    
    if w.operator_number == 100322
      operator = 'noble'
    else 
      operator = 'kerr-mcgee'
    end

    kml_string += "      <Placemark>" + newline
    kml_string += "        <styleUrl>##{operator}</styleUrl>" + newline
    kml_string += "        <Point>" + newline
    kml_string += "          <coordinates>#{w.longitude},#{w.latitude},0</coordinates>" + newline
    kml_string += "        </Point>" + newline
    kml_string += '        <description>API #: &lt;a href="http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid='
    kml_string += "#{w.link_fld}"
    kml_string += '&amp;type=WELL"&gt;' 
    kml_string += "#{w.api_number}&lt;/a&gt;</description>" + newline
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

