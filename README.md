# Cozaepp

A Ruby API for passing messages to Uniforum's EPP-based co.za registry

EPP extensions as per https://www.registry.net.za/content.php?wiki=1&contentid=112&title=What%20is%20EPP?

TODO: Some of the "Transfer" operations are yet to be implemented

N.B version 0.0.2+ requires an SSL-patched version of the epp gem found at https://github.com/tgenov/epp (I'll get around to publishing the gem on rubygems.org eventuall) for now pick an installation option:

## Installation

Option 1:

   gem install cozaepp
    
   git clone https://github.com/tgenov/epp && cd epp && rake install

Option 2:
 
   git clone https://github.com/tgenov/cozaepp && cd cozaepp && bundle install && rake install

## Usage

require "cozaepp"

epp = CozaEPP::Client.new("some.hostname.co.za","username","password")
epp.login

List of all public instance methods:

ack(messageId) click to toggle source

apply_clienthold(domainName)

create_contact(contactId, contactName, contactOrg, contactStreet1, contactStreet2, contactStreet3, contactCity, contactProvince, contactPostalcode, contactCountry, contactTel, contactFax, contactEmail, contactPassword )

#### create_domain(domainName,registrant,hosts,domainSecret)

"hosts" as a array of hashes.

```
    {
      "hostname" => 'hostname',
      "ip_v4_address" => 'IPv4 Address',
      "ip_v6_address" => 'IPv6 Address'
    }
```

Using an external NS you need only the hostname

```
create_domain(
  "testing.test.dnservices.co.za",
  "1234567891234567",
  [
    {
      "hostname" => 'ns1.domain.co.za'
    },
    {
      "hostname" => 'ns2..domain.co.za'
    }
  ],
  "coza"
)
```

Using a NS that's hostname falls part of the domain being registered, IP details are required

```
create_domain(
  "testing.test.dnservices.co.za",
  "1234567891234567",
  [
    {
      "hostname" => 'ns1.testing.test.dnservices.co.za',
      "ip_v4_address" => '1.1.1.1'
    },
    {
      "hostname" => 'ns2.testing.test.dnservices.co.za',
      "ip_v4_address" => '2.2.2.2'
    }
  ],
  "coza"
)
```

create_domain_with_host(domainName, registrant, nsHostname1, nsipv4Address1, nsipv6Address1, nsHostname2, nsipv4Address2, nsipv6Address2, domainSecret )

create_domain_with_ns(domainName, registrant, nsHostname1, nsHostname2, domainSecret )

create_host(serverHostname, ipv4Address, ipv6Address=nil)

delete_contact(contactId)

delete_domain(domainName)

info_balance(contactId)

info_contact(contactId,contactPassword)

info_contact_linkeddomains(contactId,contactPassword)

info_domain(domainName)

login()

logout()

poll()

remove_clienthold(domainName)

renew_domain(domainName,curExpiryDate)

set_autorenew(domainName, autoRenew)
-autorenew in [ "true", "false"]

transfer_approve(domainName)

transfer_domain(domainName)

update_contact(contactId, contactName, contactOrg, contactStreet1, contactStreet2, contactStreet3, contactCity, contactProvince, contactPostalcode, contactCountry, contactTel, contactFax, contactEmail, contactPassword )

update_domain_ns(domainName, nsHostname1, nsipv4Address1, nsipv6Address1)

update_domain_registrant(domainName,registrant)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
