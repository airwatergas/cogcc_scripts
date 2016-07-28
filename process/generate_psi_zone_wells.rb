# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'dj_bradenhead_wells'


# begin error trapping
begin

  start_time = Time.now
  newline = "\r"
  file_date = "20151207"
  file_name = "wells_psi_zones_#{file_date}.kml"

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase } )

  kml_string = '<?xml version="1.0" encoding="UTF-8"?>' + newline
  kml_string += '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">' + newline
  kml_string += "  <Document>" + newline

  kml_string += '    <Style id="level_0">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF00FF14</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_20">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FFFF7800</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_40">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FFFF78F0</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_60">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF14F0FF</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_80">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF1478FF</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_100">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FF0000FF</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += '    <Style id="level_na">' + newline
  kml_string += "      <IconStyle>" + newline
  kml_string += "        <scale>0.4</scale>" + newline
  kml_string += "        <Icon>" + newline
  kml_string += "          <href>http://www.earthpoint.us/Dots/GoogleEarth/pal2/icon26.png</href>" + newline
  kml_string += "        </Icon>" + newline
  kml_string += "        <color>FFF0FF14</color>" + newline
  kml_string += "      </IconStyle>" + newline
  kml_string += "    </Style>" + newline

  kml_string += "    <Folder>" + newline

  DjBradenheadWells.find_by_sql("select id, lpad(well_id::varchar,8,'0') as link_fld, api_number, longitude, latitude, psi_zone_0, psi_zone_20, psi_zone_40, psi_zone_60, psi_zone_80, psi_zone_100 from dj_bradenhead_wells order by api_number").each do |d|

    psi_level = 'na'
    if d.psi_zone_0
      psi_level = '0'
    end
    if d.psi_zone_20
      psi_level = '20'
    end
    if d.psi_zone_40
      psi_level = '40'
    end
    if d.psi_zone_60
      psi_level = '60'
    end
    if d.psi_zone_80
      psi_level = '80'
    end
    if d.psi_zone_100
      psi_level = '100'
    end

    kml_string += "      <Placemark>" + newline
    kml_string += "        <styleUrl>#level_#{psi_level}</styleUrl>" + newline
    kml_string += "        <Point>" + newline
    kml_string += "          <coordinates>#{d.longitude},#{d.latitude},0</coordinates>" + newline
    kml_string += "        </Point>" + newline
    kml_string += '        <description>API #: &lt;a href="http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid='
    kml_string += "#{d.link_fld}"
    kml_string += '&amp;type=WELL"&gt;' 
    kml_string += "#{d.api_number}&lt;/a&gt;</description>" + newline
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

