#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC COA & BMP Scraper

# while true; do ./coa_bmp_scrape.rb & sleep 6; done


# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'coa_bmp_scrapes'
require mappings_directory + 'approval_conditions'
require mappings_directory + 'best_management_practices'


# begin error trapping
begin

  start_time = Time.now

  nbsp = Nokogiri::HTML("&nbsp;").text

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  if CoaBmpScrapes.where(in_use: true).count == 0 then

  CoaBmpScrapes.find_by_sql("SELECT * FROM coa_bmp_scrapes WHERE status_code = 'DA' AND in_use IS FALSE AND scraped IS FALSE ORDER BY facility_id DESC LIMIT 1").each do |f|

    f.in_use = true
    f.save!

    # use random browser
    agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
    agent_alias = agent_aliases[rand(0..6)]

    agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

    puts agent_alias

    puts "Well #{f.well_id} in use"

    page_url = "http://cogcc.state.co.us/cogis/COAs.cfm?facid=#{f.facility_id}"

    page = agent.get(page_url)

    response = page.code.to_s

    doc = Nokogiri::HTML(page.body)

    coa_table = doc.xpath('//table[1]')
    coa_search_results = doc.at('th:contains("COA Search Results")').text
    has_coa = true
    if coa_search_results.include? "No Records Found"
      has_coa = false
    end

    bmp_table = doc.xpath('//table[2]')
    bmp_search_results = doc.at('th:contains("BMPSearch Results")').text
    has_bmp = true
    if bmp_search_results.include? "No Records Found"
      has_bmp = false
    end

    if has_coa or has_bmp

    ActiveRecord::Base.transaction do

      if has_coa

        coa_table.css('tr').each_with_index do |tr,i|

          if i >=2

            c = ApprovalConditions.new

            c.well_id = f.well_id
            c.facility_id = f.facility_id
            coa_source_html = tr.xpath('td[1]').to_html
            coa_source = coa_source_html.split('<br>')
            c.source_document_form = Nokogiri::HTML(coa_source[0]).text.gsub(nbsp, " ").strip
          	c.source_document_number = coa_source[1].gsub(nbsp, " ").strip
          	c.source_document_date = Nokogiri::HTML(coa_source[2]).text.gsub(nbsp, " ").strip
            coa_text = tr.xpath('td[2]').text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
            coa_text = coa_text.encode!('UTF-8', 'UTF-16')
            c.conditions = coa_text.gsub(nbsp, " ").strip

            puts c.inspect
            c.save!

          end

        end

      end

      if has_bmp

        bmp_table.css('tr').each_with_index do |tr,i|

          if i >=2

            b = BestManagementPractices.new

            b.well_id = f.well_id
            b.facility_id = f.facility_id
            bmp_source_html = tr.xpath('td[1]').to_html
            bmp_source = bmp_source_html.split('<br>')
            b.source_document_form = Nokogiri::HTML(bmp_source[0]).text.gsub(nbsp, " ").strip
          	b.source_document_number = bmp_source[1].gsub(nbsp, " ").strip
          	b.source_document_date = Nokogiri::HTML(bmp_source[2]).text.gsub(nbsp, " ").strip
            b.bmp_type = tr.xpath('td[2]').text.gsub(nbsp, " ").strip
            bmp_text = tr.xpath('td[3]').text.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
            bmp_text = bmp_text.encode!('UTF-8', 'UTF-16')
            b.bmp_description = bmp_text.gsub(nbsp, " ").strip

            puts b.inspect
            b.save!

          end

        end

      end

    end # end activerecord transaction block

    else

      puts "No records found"

    end # end search records exist check

    f.scraped = true
    f.in_use = false
    f.save!

  end # end scrape record

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
end








