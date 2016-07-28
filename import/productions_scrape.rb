#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Well Production Scraper

# sample URL: http://cogcc.state.co.us/cogis/ProductionWellMonthly.asp?APICounty=123&APISeq=05091&APIWB=00&Year=All

# UNIX shell script to run scraper: while true; do ./productions_scrape.rb & sleep 10; done

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'scrape_statuses'
require mappings_directory + 'production_amounts'


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

  nbsp = Nokogiri::HTML("&nbsp;").text

  if ScrapeStatuses.where(in_use: true).count == 0 then

  ScrapeStatuses.find_by_sql("SELECT * FROM scrape_statuses WHERE in_use IS FALSE AND production_scrape_status = 'not scraped' ORDER BY well_api_number LIMIT 1").each do |well|

  begin

    puts "05-#{well.well_api_county}-#{well.well_api_sequence} in use!"

    well.in_use = true
    well.save!

    ActiveRecord::Base.transaction do

      page_url = "http://cogcc.state.co.us/cogis/ProductionWellMonthly.asp?APICounty=#{well.well_api_county}&APISeq=#{well.well_api_sequence}&APIWB=00&Year=All"

      page = agent.get(page_url)

      response = page.code.to_s

      doc = Nokogiri::HTML(page.body)

      if doc.at('p:contains("No Records Found.")').nil? then

        results_table = doc.xpath('//table[@width="75%"]')

        results_table.css('tr').each_with_index do |tr,i|

          if i >= 5 then

            p = ProductionAmounts.new

            p.well_id = well.well_id
            p.production_year = tr.xpath('td[1]').text.gsub(nbsp, " ").strip
            p.production_month = tr.xpath('td[2]').text.gsub(nbsp, " ").strip
            p.formation_name = tr.xpath('td[3]').text.gsub(nbsp, " ").strip
            p.sidetrack = tr.xpath('td[4]').text.gsub(nbsp, " ").strip
            p.well_status_code = tr.xpath('td[5]').text.gsub(nbsp, " ").strip
            if !tr.xpath('td[6]').text.nil? then
              p.days_producing = tr.xpath('td[6]').text.gsub(nbsp, " ").strip
            end

            td_8 = tr.xpath('td[8]')
            td_8.search('br').each do |n|
              n.replace("\n")
            end
            if !td_8.text.split("\n")[0].nil? then
              p.oil_bom = td_8.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_8.text.split("\n")[2].nil? then
              p.gas_production = td_8.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_9 = tr.xpath('td[9]')
            td_9.search('br').each do |n|
              n.replace("\n")
            end
            if !td_9.text.split("\n")[0].nil? then
              p.oil_produced = td_9.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_9.text.split("\n")[2].nil? then
              p.gas_flared = td_9.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_10 = tr.xpath('td[10]')
            td_10.search('br').each do |n|
              n.replace("\n")
            end
            if !td_10.text.split("\n")[0].nil? then
              p.oil_sold = td_10.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_10.text.split("\n")[2].nil? then
              p.gas_used = td_10.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_11 = tr.xpath('td[11]')
            td_11.search('br').each do |n|
              n.replace("\n")
            end
            if !td_11.text.split("\n")[0].nil? then
              p.oil_adj = td_11.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_11.text.split("\n")[2].nil? then
              p.gas_shrinkage = td_11.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_12 = tr.xpath('td[12]')
            td_12.search('br').each do |n|
              n.replace("\n")
            end
            if !td_12.text.split("\n")[0].nil? then
              p.oil_eom = td_12.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_12.text.split("\n")[2].nil? then
              p.gas_sold = td_12.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_13 = tr.xpath('td[13]')
            td_13.search('br').each do |n|
              n.replace("\n")
            end
            if !td_13.text.split("\n")[0].nil? then
              p.oil_gravity = td_13.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_13.text.split("\n")[2].nil? then
              p.gas_btu = td_13.text.split("\n")[2].gsub(nbsp, " ").strip
            end

            td_14 = tr.xpath('td[14]')
            td_14.search('br').each do |n|
              n.replace("\n")
            end
            if !td_14.text.split("\n")[0].nil? then
              p.water_production = td_14.text.split("\n")[0].gsub(nbsp, " ").strip
            end
            if !td_14.text.split("\n")[1].nil? then
              p.water_disposal_code = td_14.text.split("\n")[1].gsub(nbsp, " ").strip
            end

            puts p.inspect
            p.save!

          end 

        end # end table row loop

        well.production_scrape_status = "data saved"

      else

        well.production_scrape_status = "data not found"

      end # end results check      

      well.in_use = false
      well.save!

    end # activerecord transaction

    rescue Mechanize::ResponseCodeError => e
      well.production_scrape_status = "data not found"
      well.in_use = false
      well.save!
      puts "ResponseCodeError: " + e.to_s
    end

    puts "Well production scrape completed!"

  end # end well loop

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end