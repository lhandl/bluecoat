#!/usr/bin/env ruby
require 'open-uri'
require 'cgi'
require 'uri'
require 'mechanize'
require 'ipaddress'


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
  # this class provides methods to query blue coat sg
  class SG
    # constructor connects to bluecoat sg
    # options are: :host, :port, :username and :password
    def initialize(options = {})
      @host = options[:host]
      @port = options[:port].nil? ? "8082" : options[:port]
      @user = options[:user]
      @pass = options[:pass]
    end

    # fetches the whole policy from blue coat sg
    def fetch_policy(options = {})
      if @policy.nil? || options[:no_caching] then
        mech = Mechanize.new
        mech.auth(@user, @pass)
        page = mech.get("https://#{@host}:#{@port}/Policy/Current")
        @policy = page.parser.xpath('/html/body/pre').inner_text
      end
      @policy
    end

    # fetches a subnet definition from the policy, an array of ip addresses and subnets is returned
    def fetch_subnet(name, options = {})
       rc = []
       policy = fetch_policy(options)
       policy.scan(/define subnet "#{name}"(.+?)end/m)
       rc += $1.delete("\r\n").split(" ").map{|s| IPAddress s} if !$1.nil?
       policy.scan(/define subnet #{name}(.+?)end/m)
       rc += $1.delete("\r\n").split(" ").map{|s| IPAddress s} if !$1.nil?
       rc
    end
  end
end

