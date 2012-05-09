#!/usr/bin/env ruby
require 'open-uri'
require 'cgi'
require 'uri'
require 'csv'
require 'mechanize'


# the class is extended by a function to_query which converts the hash to an URI-String
class Hash
  # converts hash to URI parameter string
  def to_query
    elements = []
    keys.size.times do |i|
      elements << "#{keys[i]}=#{values[i]}"
    end
    elements.join('&')
  end
end


module BlueCoat
  # this class provides methods to query blue coat reporter
  class Reporter
    # constructor
    def initialize(options = {})
      # concat URL-string
      @connect = "https://#{options[:host]}:8082/api/"
      @credentials = "?username=#{options[:user]}&password=#{options[:pass]}&role=#{options[:role]}"
    end


    # triggers the Blue Coat Reporter to send a PDF report by email.
    def mail_report(params)
      # default Parameter fuers Hash
      params[:label] ||= "unspecified report"
      file = open "#{@connect}create#{@credentials}&action=email&format=pdf&#{URI.escape(params.to_query, "| ")}", :proxy => nil
      report_id = file.gets.split(":")[1]
      file.close

      # wait for report
      status = ""
      begin
        sleep 1
        file = open "#{@connect}status#{@credentials}&reportId=#{report_id}", :proxy => nil
        file.gets
        file.gets
        status = file.gets.split(":")[1]
        file.close
      end while status == "Running\n"

      # clear open report request from reporter
      file = open "#{@connect}cancel#{@credentials}&reportId=#{report_id}", :proxy => nil
      file.close
    end


    # fetches a report from the Blue Coat Reporter. The report is returned in a two-dimensional array.
    # params are as by Blue Coat Reporter WEB API
    def fetch_report(params)
      # default Parameter fuers Hash
      params[:label] ||= "unspecified report"

      # start report
      file = open "#{@connect}create#{@credentials}&action=download&format=csv&#{URI.escape(params.to_query, "| ")}", :proxy => nil
      report_id = file.gets.split(":")[1]
      file.close

      # wait for report
      status = ""
      begin
        sleep 1
        file = open "#{@connect}status#{@credentials}&reportId=#{report_id}", :proxy => nil
        file.gets
        file.gets
        status = file.gets.split(":")[1]
        file.close
      end while status == "Running\n"

      # fetch ready report
      file = open "#{@connect}download#{@credentials}&reportId=#{report_id}", :proxy => nil
      rc = file.readlines.join("")
      file.close

      # parse csv and convert to array
      rc = CSV.parse(rc).to_a

      # clear open report request from reporter
      file = open "#{@connect}cancel#{@credentials}&reportId=#{report_id}", :proxy => nil
      file.close

      # remove headline from array
      rc.slice!(0)

      # convert all found integer-strings to intergers
      rc.map do |row|
        row.map do |col|
          begin
            oldcol = col
            col = Integer(col)
          rescue
            col = oldcol
          end
        end
      end
    end
  end
end
