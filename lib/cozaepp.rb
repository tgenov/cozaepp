require "socket"
require "time"
require "securerandom"
require "erb"
require "epp"
require "cozaepp/version"

module CozaEPP
  class Client
    def initialize(server, tag, password, sslcert = nil, sslkey = nil, port = 3121)
      raise ArgumentError unless server and tag and password
      @gemRoot = Gem::Specification.find_by_name("cozaepp").gem_dir
      @eppTag = tag
      @eppPassword = password
      @epp = Epp::Server.new(
        :server => server,
        :port => port,
        :tag => tag,
        :password => password,
        :sslcert => sslcert,
        :sslkey => sslkey
      )
      @epp.open_connection
    end

    def login
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/login.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid}
    end

    def logout
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/logout.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def poll
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/poll.erb")).result(binding)
      result = @epp.send_request(xml)
      puts result
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      if statusCode == "1300"
        return {:status => statusCode, \
                :text => statusMsg, \
                :cltrid => cltrid, \
                :svtrid => svtrid
              }
      elsif statusCode == "1301"
        msgId = Hpricot::XML(result).at("//epp:epp//epp:response//epp:msgQ")[:id]
        msgDate = Hpricot::XML(result).at("//epp:epp//epp:response//epp:msgQ//epp:qDate/")
        msgText = Hpricot::XML(result).at("//epp:epp//epp:response//epp:msgQ//epp:msg/")
        msgCount = Hpricot::XML(result).at("//epp:epp//epp:response//epp:msgQ")[:count]
        return {:status => statusCode, \
                :text => statusMsg, \
                :cltrid => cltrid, \
                :svtrid => svtrid, \
                :msgcount => msgCount, \
                :msgid =>  msgId, \
                :msgdate => msgDate, \
                :msgtext => msgText}
      end
    end

    def ack(messageId)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/poll_ack.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def add_ns_host(domainName,
                    nsHostname1,
                    nsipv4Address1)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/add_ns.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def cancel_action(domainName,
                      actionName)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/cancel_action.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }     
    end

    def create_contact(contactId,
                       contactName,
                       contactOrg,
                       contactStreet1,
                       contactStreet2,
                       contactStreet3,
                       contactCity,
                       contactProvince,
                       contactPostalcode,
                       contactCountry,
                       contactTel,
                       contactFax,
                       contactEmail,
                       contactPassword
      )
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/create_contact.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def update_contact(contactId,
                       contactName,
                       contactOrg,
                       contactStreet1,
                       contactStreet2,
                       contactStreet3,
                       contactCity,
                       contactProvince,
                       contactPostalcode,
                       contactCountry,
                       contactTel,
                       contactFax,
                       contactEmail,
                       contactPassword
      )
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/update_contact.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def update_domain_registrant(domainName,registrant)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/update_domain_registrant.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def update_domain_ns(domainName,
                         nsHostname1,
                         nsipv4Address1,
                         nsipv6Address1)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/update_domain_ns.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def info_contact(contactId,contactPassword)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/info_contact.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      if statusCode == "1000" then
        resData = Hpricot::XML(result).at("//epp:epp//epp:response//epp:resData//")
        infoContact = {
          :contactStatus => Array.new,
          :contactName => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:name/"),
          :contactOrg => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:org/"),
          :contactStreet => Array.new,
          :contactCity => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:addr//contact:city/"),
          :contactSp => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:addr//contact:sp/"),
          :contactPc => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:addr//contact:pc/"),
          :contactCc => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:postalInfo//contact:addr//contact:cc/"),
          :contactVoice => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:voice/"),
          :contactFax => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:fax/"),
          :contactEmail => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:email/"),
          :contactVoice => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:voice/"),
          :contactClID => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:clID/"),
          :contactCrID => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:crID/"),
          :contactCrDate => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:crDate/"),
          :contactUpID => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:upID/"),
          :contactUpDate => Hpricot::XML(resData.to_s).at("//epp:resData//contact:infData//contact:upDate/"),
        }
        Hpricot::XML(resData.to_s).search("//epp:resData//contact:infData//contact:status//s/").each do |status|
          infoContact[:contactStatus] << status
        end
        Hpricot::XML(resData.to_s).search("//epp:resData//contact:infData//contact:postalInfo//contact:addr//contact:street/").each do |street|
          infoContact[:contactStreet] << street
        end
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :resdata => resData }
      else
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
      end
    end

    def info_contact_linkeddomains(contactId,contactPassword)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/info_contact_coza.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      domainData = Hpricot::XML(result).at("//epp:epp//epp:response//epp:extension//cozac:infData//")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :domaindata => domainData }
    end

    def info_balance(contactId)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/info_balance.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      balance = Hpricot::XML(result).at("//epp:epp//epp:response//epp:extension//cozac:balance/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :balance => balance}
    end

    def info_domain(domainName)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/info_domain.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      if statusCode == "1000" then
        resData = Hpricot::XML(result).at("//epp:epp//epp:response//epp:resData//")
        infoDomain = {
          :domainName => Hpricot::XML(resData.to_s).at("//epp:resData//domain:infData//domain:name/"),
          :domainRoid => Hpricot::XML(resData.to_s).at("//epp:resData//domain:infData//domain:roid/"),
          :domainNs => Array.new,
          :domainClID => Hpricot::XML(resData.to_s).at("//epp:resData//domain:infData//domain:clID/"),
        }
        Hpricot::XML(resData.to_s).search("//epp:resData//domain:infData//domain:ns//domain:hostAttr//domain:hostName/").each do |ns|
          infoDomain[:domainNs] << ns
        end
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :resdata => infoDomain }
      else
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
      end
    end

    def create_host(serverHostname, ipv4Address, ipv6Address=nil)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/create_host.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def create_domain_with_ns(domainName,
                      registrant,
                      nsHostname1,
                      nsHostname2,
                      domainSecret
                      )

      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/create_domain_with_ns.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def create_domain_with_host(domainName,
                      registrant,
                      nsHostname1,
                      nsipv4Address1,
                      nsipv6Address1,
                      nsHostname2,
                      nsipv4Address2,
                      nsipv6Address2,
                      domainSecret
                      )

      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/create_domain_with_host.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def delete_domain(domainName)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/delete_domain.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def delete_contact(contactId)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/delete_contact.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def check_domain(domainName)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/check_domain.erb")).result(binding)
        result = @epp.send_request(xml)
        puts result
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def delete_ns(domainName,
                  nsHostname)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/delete_ns.erb")).result(binding)
      result = @epp.send_request(xml)
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def renew_domain(domainName,curExpiryDate)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/renew.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    #autorenew in [ "true", "false"]
    def set_autorenew(domainName, autoRenew)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/set_autorenew.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def apply_clienthold(domainName)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/apply_clienthold.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def remove_clienthold(domainName)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/remove_clienthold.erb")).result(binding)
        result = @epp.send_request(xml)
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid }
    end

    def transfer_domain(domainName)
        cltrid = gen_cltrid
        xml = ERB.new(File.read(@gemRoot + "/erb/transfer_domain.erb")).result(binding)
        result = @epp.send_request(xml)
        puts result
        statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
        statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
        svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
        resData = Hpricot::XML(result).at("//epp:epp//epp:response//epp:resData//")
        return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :resdata => resData }
    end

    def transfer_approve(domainName)
      cltrid = gen_cltrid
      xml = ERB.new(File.read(@gemRoot + "/erb/transfer_approve.erb")).result(binding)
      result = @epp.send_request(xml)
      puts result
      statusCode = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result")[:code]
      statusMsg = Hpricot::XML(result).at("//epp:epp//epp:response//epp:result//epp:msg/")
      svtrid = Hpricot::XML(result).at("//epp:epp//epp:response//epp:trID//epp:svTRID/")
      resData = Hpricot::XML(result).at("//epp:epp//epp:response//epp:resData//")
      return {:status => statusCode, :text => statusMsg, :cltrid => cltrid, :svtrid => svtrid, :resdata => resData }
    end

    private
    def gen_cltrid
      return "MTNBUS-" + Time.now.to_i.to_s + "-" + gen_random_string
    end

    private
    def gen_random_string(length=32)
        chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
        Array.new(length) { chars[rand(chars.length)].chr }.join
    end

  end
end

