require "socket"
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
      self.login
    end

    def login
      xml = ERB.new(File.read(@gemRoot + "/erb/login.erb")).result
      puts xml
    end
  
  end
end

