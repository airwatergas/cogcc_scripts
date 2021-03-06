#!/Users/troyburke/.rvm/rubies/ruby-2.1.2/bin/ruby

# COGCC Spill Document Cataloger

# UNIX shell script to run scraper: while true; do ./spill_document_cataloger.rb & sleep 5; done

# fetch the following link for each well id:  http://ogccweblink.state.co.us/results.aspx?id=11506009
# read document table and store information/document links
# then go back and target documents based on catalog
# DOWNLOAD LINK => http://ogccweblink.state.co.us/DownloadDocument.aspx?DocumentId=_document_id_

# Include required classes and models:

require '../import_data_config'

require 'rubygems'
require 'active_record'
require 'pg'
require 'mechanize'
require 'nokogiri'

# Include database table models:

mappings_directory = getMappings

require mappings_directory + 'spill_releases'
require mappings_directory + 'spill_release_documents'


# begin error trapping
begin

  start_time = Time.now

  # Establish a database connection
  ActiveRecord::Base.establish_connection( { adapter: 'postgresql', host: getDBHost, port: getDBPort, username: getDBUsername, database: getDBDatabase, schema_search_path: getDBSchema } )

  if SpillReleases.where(in_use: true).count == 0 then

  #SpillReleases.find_by_sql("SELECT * FROM spill_releases WHERE in_use IS FALSE AND documents_indexed IS FALSE AND left(document_url,1) = 'F' AND facility_id IS NOT NULL LIMIT 1").each do |spill|
  SpillReleases.find_by_sql("SELECT * FROM spill_releases WHERE in_use IS FALSE AND documents_indexed IS FALSE AND left(document_url,1) = 'S' and document_number is not null LIMIT 1").each do |spill|

  # use random browser
  agent_aliases = [ 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Firefox' ]
  agent_alias = agent_aliases[rand(0..6)]

  agent = Mechanize.new { |agent| agent.user_agent_alias = agent_alias }

  puts agent_alias

  begin

    spill.in_use = true
    spill.save!

    ActiveRecord::Base.transaction do

      # set url
      #url = "http://ogccweblink.state.co.us/results.aspx?id=#{spill.facility_id}"
      url = "http://ogccweblink.state.co.us/results.aspx?id=#{spill.document_number}"

      puts url

      # get http response code to check for valid url
      page = agent.head(url)
      response = page.code.to_s

      # retreive body html
      html = agent.get(url).body
      first_page = Nokogiri::HTML(html)

      # grab all links on first page
      links = first_page.xpath("//a[starts-with(@href, 'DownloadDocument')]")

      # find link count and doc count (always 5 links per table row)
      link_count = links.length

      if link_count > 0 then

        ActiveRecord::Base.transaction do

          doc_count = link_count/5

          # loop over each table row
          (0..link_count-1).step(5) do |i|

            doc_pointer = i + 5

            doc_link = links[i]

            d = SpillReleaseDocuments.new
            d.spill_release_id = spill.id
            d.facility_id = spill.facility_id
            download_link = doc_link['href'].to_s
            d.document_id = download_link.match('=').post_match
            d.document_number = links[doc_pointer-3].text.to_s
            d.document_name = links[doc_pointer-2].text.to_s
            d.document_date = links[doc_pointer-1].text.to_s
            d.download_url = download_link
            d.save!

          end

          # check for pagination links
          pages = first_page.xpath("//a[contains(@href, 'Page')]")

          if pages.length > 0 then

            post_page = first_page

            pages.each_with_index do |page,p|

              page_num = p + 2

              page_target = "Page$#{page_num}"

              next_page = agent.post(url, {
                "__EVENTTARGET" => "WQResultGridView",
                "__EVENTARGUMENT" => "#{page_target}",
                "__VIEWSTATE" => post_page.at('input[@name="__VIEWSTATE"]')['value'],
                "__EVENTVALIDATION" => post_page.at('input[@name="__EVENTVALIDATION"]')['value'],
              })

              post_results = Nokogiri.HTML(next_page.body)

              post_page = post_results

              # grab all links on first page
              links = post_page.xpath("//a[starts-with(@href, 'DownloadDocument')]")

              # find link count and doc count (always 5 links per table row)
              link_count = links.length

              doc_count = link_count/5

              # loop over each table row
              (0..link_count-1).step(5) do |i|

                doc_pointer = i + 5

                doc_link = links[i]

                d = SpillReleaseDocuments.new
                d.spill_release_id = spill.id
                d.facility_id = spill.facility_id
                download_link = doc_link['href'].to_s
                d.document_id = download_link.match('=').post_match
                d.document_number = links[doc_pointer-3].text.to_s
                d.document_name = links[doc_pointer-2].text.to_s
                d.document_date = links[doc_pointer-1].text.to_s
                d.download_url = download_link
                d.save!

              end # additional page document links

            end # additional link pages

          end # check for multiple pages

          spill.documents_indexed = true
          spill.in_use = false
          spill.save!
          puts "Document table scraped!"

        end # activerecord transaction

      else # no document links found

        spill.documents_indexed = true
        spill.in_use = false
        spill.save!
        puts "No documents found."

      end # first page doc link check

    end # activerecord transaction

    rescue Mechanize::ResponseCodeError => e
      spill.documents_indexed = true
      spill.in_use = false
      spill.save!
      puts "ResponseCodeError: " + e.to_s
    end

  end # query loop

  end # in use check

  puts "Time Start: #{start_time}"
  puts "Time End: #{Time.now}"

  rescue Exception => e
    puts e.message
  end
#end