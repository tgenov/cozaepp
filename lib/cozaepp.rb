require "socket"
require "time"
require "securerandom"
require "erb"
require "epp"
require "cozaepp/version"

module CozaEPP
  class Client
    def initialize(server, tag, password, port = 3121)  
      raise ArgumentError unless server and tag and password
      @gemRoot = Gem::Specification.find_by_name("cozaepp").gem_dir
      @eppTag = tag
      @eppPassword = password
      @epp = Epp::Server.new(
        :server => server,
        :port => port,
        :tag => tag,
        :password => password
      )
      @epp.open_connection
    end

    def login
      cltrid = Time.now.strftime("MTNBUS-%Y%m%d-%H%m%S-" + gen_random_string)
      xml = ERB.new(File.read(@gemRoot + "/erb/login.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      return {:status => statusCode, :text => statusMsg, :cltrid => ctltrid }
    end
    
    def logout
      cltrid = Time.now.strftime("MTNBUS-%Y%m%d-%H%m%S-" + gen_random_string)
      xml = ERB.new(File.read(@gemRoot + "/erb/logout.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      return {:status => statusCode, :text => statusMsg, :cltrid => ctltrid }
    end
    
    private
    
    def gen_random_string(length=32)
        chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'  
        Array.new(length) { chars[rand(chars.length)].chr }.join  
    end
  
  end
end

